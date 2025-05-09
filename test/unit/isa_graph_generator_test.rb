# frozen_string_literal: true

require 'test_helper'

class IsaGraphGeneratorTest < ActiveSupport::TestCase
  test 'investigation with studies and assays' do
    assay = FactoryBot.create(:assay)
    study = assay.study
    investigation = assay.investigation
    assay2 = FactoryBot.create(:assay, contributor: assay.contributor, study: study)

    generator = Seek::IsaGraphGenerator.new(investigation)

    # Shallow
    shallow_result = generator.generate

    assert_equal 2, shallow_result[:nodes].map(&:object).length # Investigation, Study
    assert_equal 1, shallow_result[:edges].length

    assert_includes shallow_result[:nodes].map(&:object), investigation
    assert_includes shallow_result[:nodes].map(&:object), study
    refute_includes shallow_result[:nodes].map(&:object), assay
    refute_includes shallow_result[:nodes].map(&:object), assay2

    assert_includes shallow_result[:edges], [investigation, study]

    # Deep
    deep_result = generator.generate(depth: nil)

    assert_equal 4, deep_result[:nodes].map(&:object).length # Investigation, Study, 2 Assays
    assert_equal 3, deep_result[:edges].length

    assert_includes deep_result[:nodes].map(&:object), investigation
    assert_includes deep_result[:nodes].map(&:object), study
    assert_includes deep_result[:nodes].map(&:object), assay
    assert_includes deep_result[:nodes].map(&:object), assay2

    assert_includes deep_result[:edges], [investigation, study]
    assert_includes deep_result[:edges], [study, assay]
    assert_includes deep_result[:edges], [study, assay2]
  end

  test "does not show sibling's children" do
    assay = FactoryBot.create(:assay)
    study = assay.study
    sibling_assay = FactoryBot.create(:assay, title: 'sibling', contributor: assay.contributor, study: study)
    data_file = FactoryBot.create(:data_file, title: 'child', policy: FactoryBot.create(:publicly_viewable_policy))
    nephew_model = FactoryBot.create(:model, title: 'nephew', policy: FactoryBot.create(:publicly_viewable_policy))
    niece_sop = FactoryBot.create(:sop, title: 'niece', policy: FactoryBot.create(:publicly_viewable_policy))

    User.with_current_user(assay.contributor.user) do
      AssayAsset.create!(assay: assay, asset: data_file)
      AssayAsset.create!(assay: sibling_assay, asset: nephew_model)
      AssayAsset.create!(assay: sibling_assay, asset: niece_sop)
    end

    result = Seek::IsaGraphGenerator.new(assay).generate(parent_depth: nil, sibling_depth: 1)

    assert_equal 5, result[:nodes].length # Investigation, Study, 2 Assays, DataFile
    assert_equal 4, result[:edges].length

    assert_includes result[:nodes].map(&:object), assay
    assert_includes result[:nodes].map(&:object), data_file
    assert_includes result[:nodes].map(&:object), sibling_assay
    assert_equal 2, result[:nodes].detect { |n| n.object == sibling_assay }.child_count
    refute_includes result[:nodes].map(&:object), nephew_model
    refute_includes result[:nodes].map(&:object), niece_sop
  end

  test "can show sibling's children" do
    assay = FactoryBot.create(:assay)
    study = assay.study
    sibling_assay = FactoryBot.create(:assay, title: 'sibling', contributor: assay.contributor, study: study)
    data_file = FactoryBot.create(:data_file, title: 'child', policy: FactoryBot.create(:publicly_viewable_policy))
    nephew_model = FactoryBot.create(:model, title: 'nephew', policy: FactoryBot.create(:publicly_viewable_policy))
    niece_sop = FactoryBot.create(:sop, title: 'niece', policy: FactoryBot.create(:publicly_viewable_policy))

    User.with_current_user(assay.contributor.user) do
      AssayAsset.create!(assay: assay, asset: data_file)
      AssayAsset.create!(assay: sibling_assay, asset: nephew_model)
      AssayAsset.create!(assay: sibling_assay, asset: niece_sop)
    end

    result = Seek::IsaGraphGenerator.new(assay).generate(parent_depth: nil, sibling_depth: nil)

    assert_equal 7, result[:nodes].length # Investigation, Study, 2 Assays, DataFile, Model, Sop
    assert_equal 6, result[:edges].length

    assert_includes result[:nodes].map(&:object), assay
    assert_includes result[:nodes].map(&:object), data_file
    assert_includes result[:nodes].map(&:object), sibling_assay
    assert_includes result[:nodes].map(&:object), nephew_model
    assert_includes result[:nodes].map(&:object), niece_sop
  end

  test 'maintains child asset count even if the are not included in graph' do
    assay = FactoryBot.create(:assay)
    study = assay.study
    investigation = assay.investigation
    assay2 = FactoryBot.create(:assay, contributor: assay.contributor, study: study)
    generator = Seek::IsaGraphGenerator.new(investigation)
    result = generator.generate

    study_node = result[:nodes].detect { |n| n.object == study }

    assert_equal 2, study_node.child_count
    refute_includes result[:nodes].map(&:object), assay
    refute_includes result[:nodes].map(&:object), assay2
  end

  test 'counts child assets of all ancestors' do
    person = FactoryBot.create(:person)
    project = person.projects.first
    investigation = FactoryBot.create(:investigation, contributor: person, projects: [project])
    investigation2 = FactoryBot.create(:investigation, contributor: person, projects: [project])
    investigation3 = FactoryBot.create(:investigation, contributor: person, projects: [project])
    study = FactoryBot.create(:study, contributor: person, investigation: investigation)
    study2 = FactoryBot.create(:study, contributor: person, investigation: investigation)
    study3 = FactoryBot.create(:study, contributor: person, investigation: investigation)
    study4 = FactoryBot.create(:study, contributor: person, investigation: investigation)
    assay = FactoryBot.create(:assay, contributor: person, study: study)

    generator = Seek::IsaGraphGenerator.new(assay)
    result = generator.generate(parent_depth: nil)

    investigation_node = result[:nodes].detect { |n| n.object == investigation }

    refute_nil investigation_node

    assert_equal 4, investigation_node.child_count

    assert_includes result[:nodes].map(&:object), investigation
    assert_includes result[:nodes].map(&:object), study2
    assert_includes result[:nodes].map(&:object), study3
    assert_includes result[:nodes].map(&:object), study4

    refute_includes result[:nodes].map(&:object), investigation2
    refute_includes result[:nodes].map(&:object), investigation3
  end

  test 'shows direct associations rather than related' do
    person = FactoryBot.create(:person)
    publication = FactoryBot.create(:publication)
    publication2 = FactoryBot.create(:publication)
    assay = FactoryBot.create(:assay, contributor: person, publications: [publication])
    disable_authorization_checks { assay.study.publications << publication2 }

    assert_equal [publication], assay.publications
    assert_equal [publication], assay.related_publications

    assert_equal [publication2], assay.study.publications
    assert_equal [publication, publication2].sort, assay.study.related_publications.sort

    assert_empty assay.study.investigation.publications
    assert_equal [publication, publication2].sort, assay.study.investigation.related_publications.sort

    generator = Seek::IsaGraphGenerator.new(assay)
    result = generator.generate(parent_depth: nil)

    assert_equal 5, result[:nodes].count
    assert_equal 4, result[:edges].count

    assay_pub_edges = result[:edges].select { |edge| edge.include?(assay) && edge.include?(publication) }
    assert_equal 1, assay_pub_edges.count
    assay_pub_edges = result[:edges].select { |edge| edge.include?(assay) && edge.include?(publication2) }
    assert_empty assay_pub_edges

    study_pub_edges = result[:edges].select { |edge| edge.include?(assay.study) && edge.include?(publication) }
    assert_empty study_pub_edges

    study_pub_edges = result[:edges].select { |edge| edge.include?(assay.study) && edge.include?(publication2) }
    assert_equal 1, study_pub_edges.count

    inv_pub_edges = result[:edges].select { |edge| edge.include?(assay.study.investigation) && edge.include?(publication) }
    assert_empty inv_pub_edges
    inv_pub_edges = result[:edges].select { |edge| edge.include?(assay.study.investigation) && edge.include?(publication2) }
    assert_empty inv_pub_edges

  end

  test 'aggregated_children' do
    assert_equal 5, Seek::IsaGraphGenerator::MIN_AGGREGATED_CHILDREN
    person = FactoryBot.create(:person)
    samples = FactoryBot.create_list(:sample, 6, contributor: person)
    obs_unit = FactoryBot.create(:observation_unit, contributor: person, samples: samples)
    assert_equal 6, obs_unit.samples.count

    generator = Seek::IsaGraphGenerator.new(obs_unit)
    result = generator.generate(parent_depth: nil)

    assert_equal 3, result[:edges].count
    assert_equal 1, result[:edges].select { |edge| edge[1].is_a?(Seek::ObjectAggregation) }.count
    assert_equal 0, result[:edges].select { |edge| edge[1].is_a?(Sample) }.count
    assert_equal 4, result[:nodes].count
    assert_equal 1, result[:nodes].select { |node| node.object.is_a?(Seek::ObjectAggregation) }.count
    assert_equal 0, result[:nodes].select { |node| node.object.is_a?(Sample) }.count

    #below threshold
    samples = FactoryBot.create_list(:sample, 5, contributor: person)
    obs_unit = FactoryBot.create(:observation_unit, contributor: person, samples: samples)
    assert_equal 5, obs_unit.samples.count

    generator = Seek::IsaGraphGenerator.new(obs_unit)
    result = generator.generate(parent_depth: nil)

    assert_equal 7, result[:edges].count
    assert_equal 0, result[:edges].select { |edge| edge[1].is_a?(Seek::ObjectAggregation) }.count
    assert_equal 5, result[:edges].select { |edge| edge[1].is_a?(Sample) }.count
    assert_equal 8, result[:nodes].count
    assert_equal 0, result[:nodes].select { |node| node.object.is_a?(Seek::ObjectAggregation) }.count
    assert_equal 5, result[:nodes].select { |node| node.object.is_a?(Sample) }.count
  end
end
