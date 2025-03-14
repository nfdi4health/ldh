class Assay < ApplicationRecord
  include Seek::Ontologies::AssayOntologyTypes

  enum status: %i[planned running completed cancelled failed]
  belongs_to :assignee, class_name: 'Person'

  # needs to before acts_as_isa - otherwise auto_index=>false is overridden by Seek::Search::CommonFields
  if Seek::Config.solr_enabled
    searchable(auto_index: false) do
      text :organism_terms, :human_disease_terms, :assay_type_label, :technology_type_label

      text :strains do
        strains.compact.map(&:title)
      end
    end
  end

  # needs to be declared before acts_as_isa, else ProjectAssociation module gets pulled in
  belongs_to :study
  has_many :projects, through: :study
  has_filter :project

  acts_as_isa
  acts_as_snapshottable

  belongs_to :sample_type

  has_many :child_assays, class_name: 'Assay', foreign_key: 'assay_stream_id', dependent: :destroy
  belongs_to :assay_stream, class_name: 'Assay', optional: true

  belongs_to :assay_class
  has_many :assay_organisms, dependent: :destroy, inverse_of: :assay
  has_many :organisms, through: :assay_organisms, inverse_of: :assays
  has_many :assay_human_diseases, dependent: :destroy, inverse_of: :assay
  has_many :human_diseases, through: :assay_human_diseases, inverse_of: :assays
  has_filter :organism
  has_filter :human_disease
  has_many :strains, through: :assay_organisms
  has_many :tissue_and_cell_types, through: :assay_organisms

  before_save { assay_assets.each(&:set_version) }
  has_many :assay_assets, dependent: :destroy, inverse_of: :assay, autosave: true

  has_many :data_files, through: :assay_assets, source: :asset, source_type: 'DataFile', inverse_of: :assays
  has_many :placeholders, through: :assay_assets, source: :asset, source_type: 'Placeholder', inverse_of: :assays
  has_many :sops, through: :assay_assets, source: :asset, source_type: 'Sop', inverse_of: :assays
  has_many :models, through: :assay_assets, source: :asset, source_type: 'Model', inverse_of: :assays
  has_many :samples, through: :assay_assets, source: :asset, source_type: 'Sample', inverse_of: :assays
  has_many :documents, through: :assay_assets, source: :asset, source_type: 'Document', inverse_of: :assays
  has_many :observation_units, through: :samples


  has_one :investigation, through: :study
  has_one :external_asset, as: :seek_entity, dependent: :destroy

  validates :assay_type_uri, presence: true
  validates_with AssayTypeUriValidator
  validates :technology_type_uri, absence: true, if: :is_modelling?
  validates_with TechnologyTypeUriValidator
  validates_presence_of :contributor
  validates_presence_of :assay_class
  validates :study, presence: { message: 'must be selected and valid' }, projects: true
  validate :study_matches_observation_units_if_present

  before_validation :default_assay_and_technology_type

  # a temporary store of added assets - see AssayReindexer
  attr_reader :pending_related_assets

  has_filter :assay_class, :assay_type, :technology_type

  enforce_authorization_on_association :study, :view

  # the associated projects from the Investigation.
  # Overrides the :through :study, as that relies on being saved to the database first, causing validation issues
  def projects
    study&.projects || []
  end

  def is_assay_stream?
    assay_class&.is_assay_stream?
  end

  def previous_linked_sample_type
    return unless is_isa_json_compliant?

    if is_assay_stream? || first_assay_in_stream?
      study.sample_types.second
    else
      sample_type.previous_linked_sample_type
    end
  end

  def has_linked_child_assay?
    return false unless is_isa_json_compliant?

    if is_assay_stream?
      child_assays.any?
    else
      sample_type&.linked_sample_attributes&.any?
    end
  end

  def next_linked_child_assay
    return unless has_linked_child_assay?

    if is_assay_stream?
      first_assay_in_stream
    else
      sample_type.next_linked_sample_types.map(&:assays).flatten.detect { |a| a.assay_stream_id == assay_stream_id }
    end
  end

  def first_assay_in_stream
    if is_assay_stream?
      child_assays.detect { |a| a.sample_type.previous_linked_sample_type == a.study.sample_types.second }
    else
      assay_stream.child_assays.detect { |a| a.sample_type.previous_linked_sample_type == a.study.sample_types.second }
    end
  end

  def first_assay_in_stream?
    self == first_assay_in_stream
  end

  def default_contributor
    User.current_user.try :person
  end

  def short_description
    type = assay_type_label.nil? ? 'No type' : assay_type_label

    "#{title} (#{type})"
  end

  def state_allows_delete?(*args)
    assets.empty? && publications.empty? && associated_samples_through_sample_type.empty? && super
  end

  def is_isa_json_compliant?
    investigation.is_isa_json_compliant? && (!sample_type.nil? || is_assay_stream?)
  end

  # returns true if this is a modelling class of assay
  def is_modelling?
    assay_class && assay_class.is_modelling?
  end

  # returns true if this is an experimental class of assay
  def is_experimental?
    !assay_class.nil? && assay_class.key == 'EXP'
  end

  def associated_samples_through_sample_type
    sample_type.nil? || sample_type.samples.nil? ? [] : sample_type.samples
  end

  # Create or update relationship of this assay to another, with a specific relationship type and version
  def associate(asset, options = {})
    if asset.is_a?(Organism)
      associate_organism(asset)
    elsif asset.is_a?(HumanDisease)
      associate_human_disease(asset)
    else
      assay_asset = assay_assets.detect { |aa| aa.asset == asset }

      assay_asset = assay_assets.build if assay_asset.nil?

      assay_asset.asset = asset
      assay_asset.version = asset.version if asset && asset.respond_to?(:version)
      r_type = options.delete(:relationship)
      assay_asset.relationship_type = r_type unless r_type.nil?

      direction = options.delete(:direction)
      assay_asset.direction = direction unless direction.nil?
      assay_asset.save if assay_asset.changed?

      @pending_related_assets ||= []
      @pending_related_assets << asset

      assay_asset
    end
  end

  def self.simple_associated_asset_types
    %i[models sops publications documents]
  end

  # Associations where there is additional metadata on the association, i.e. `direction`
  def self.complex_associated_asset_types
    %i[data_files samples placeholders]
  end

  def assets
    (self.class.complex_associated_asset_types + self.class.simple_associated_asset_types).inject([]) do |assets, type|
      assets + send(type)
    end
  end

  def incoming
    assay_assets.incoming.collect(&:asset)
  end

  def outgoing
    assay_assets.outgoing.collect(&:asset)
  end

  def validation_assets
    assay_assets.validation.collect(&:asset)
  end

  def construction_assets
    assay_assets.construction.collect(&:asset)
  end

  def simulation_assets
    assay_assets.simulation.collect(&:asset)
  end

  def avatar_key
    type = is_modelling? ? 'modelling' : 'experimental'
    "assay_#{type}_avatar"
  end

  def clone_with_associations
    new_object = dup
    new_object.policy = policy.deep_copy
    new_object.assay_assets = assay_assets.select do |aa|
      self.class.complex_associated_asset_types.include?(aa.asset_type.underscore.pluralize.to_sym)
    end.map(&:dup)
    self.class.simple_associated_asset_types.each do |type|
      new_object.send("#{type}=", try(type))
    end
    new_object.assay_organisms = try(:assay_organisms)
    new_object.assay_human_diseases = try(:assay_human_diseases)
    new_object
  end

  def organism_terms
    organisms.collect(&:searchable_terms).flatten
  end

  def human_disease_terms
    human_diseases.collect(&:searchable_terms).flatten
  end

  # Associates and organism with the assay
  # organism may be either an ID or Organism instance
  # strain_id should be the id of the strain
  # culture_growth should be the culture growth instance
  def associate_organism(organism, strain_id = nil, culture_growth_type = nil, tissue_and_cell_type_id = nil,
                         tissue_and_cell_type_title = nil)
    organism = Organism.find(organism) if organism.is_a?(Numeric) || organism.is_a?(String)
    strain = organism.strains.find_by_id(strain_id)
    tissue_and_cell_type = nil
    if tissue_and_cell_type_id.present?
      tissue_and_cell_type = TissueAndCellType.find_by_id(tissue_and_cell_type_id)
    elsif tissue_and_cell_type_title.present?
      tissue_and_cell_type = TissueAndCellType.where(title: tissue_and_cell_type_title).first_or_create!
    end

    return if AssayOrganism.exists_for?(self, organism, strain, culture_growth_type, tissue_and_cell_type)

    assay_organism = AssayOrganism.new(assay: self, organism:, culture_growth_type:,
                                       strain:, tissue_and_cell_type:)
    assay_organisms << assay_organism
  end

  # Associates a human disease with the assay
  # human disease may be either an ID or HumanDisease instance
  def associate_human_disease(human_disease)
    human_disease = HumanDisease.find(human_disease) if human_disease.is_a?(Numeric) || human_disease.is_a?(String)
    assay_human_disease = AssayHumanDisease.new(assay: self, human_disease:)

    return if AssayHumanDisease.exists_for?(human_disease, self)

    assay_human_diseases << assay_human_disease
  end

  # overides that from Seek::RDF::RdfGeneration, as Assay entity depends upon the AssayClass (modelling, or experimental) of the Assay
  def rdf_type_entity_fragment
    { 'EXP' => 'Experimental_assay', 'MODEL' => 'Modelling_analysis' }[assay_class.key]
  end

  def external_asset_search_terms
    external_asset ? external_asset.search_terms : []
  end

  def samples_attributes=(attributes)
    set_assay_assets_for('Sample', attributes)
  end

  def data_files_attributes=(attributes)
    set_assay_assets_for('DataFile', attributes)
  end

  def placeholders_attributes=(attributes)
    set_assay_assets_for('Placeholder', attributes)
  end

  def self.filter_by_projects(projects)
    joins(:projects).where(studies: { investigations: { investigations_projects: { project_id: projects } } })
  end

  private

  def study_matches_observation_units_if_present
    return if samples.empty?
    samples.each do |sample|
      if sample.observation_unit && sample.observation_unit.study != study
          errors.add(:study, 'must match the associated observation unit')
          return false
      end
    end
  end

  def set_assay_assets_for(type, attributes)
    type_assay_assets, other_assay_assets = assay_assets.partition { |aa| aa.asset_type == type }
    new_type_assay_assets = []

    attributes.each do |attrs|
      attrs.merge!(asset_type: type)
      existing = type_assay_assets.detect { |aa| aa.asset_id.to_s == attrs['asset_id'] }
      if existing
        new_type_assay_assets << existing.tap { |e| e.assign_attributes(attrs) }
      else
        aa = assay_assets.build(attrs)
        new_type_assay_assets << aa if aa.asset && aa.asset.can_view?
      end
    end

    self.assay_assets = (other_assay_assets + new_type_assay_assets)
    assay_assets
  end

  def related_publication_ids
    publication_ids
  end

  def related_sop_ids
    sop_ids
  end

  def related_data_file_ids
    data_file_ids
  end
end
