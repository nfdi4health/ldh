puts 'Seeding NFDI4Health MDS 3.2 to Investigation Extended Metadata ...'

@bool_type = SampleAttributeType.find_or_initialize_by(title: 'Boolean')
@bool_type.update(base_type: Seek::Samples::BaseType::BOOLEAN)

@int_type = SampleAttributeType.find_or_initialize_by(title: 'Integer')
@int_type.update(base_type: Seek::Samples::BaseType::INTEGER, placeholder: '1')

@float_type = SampleAttributeType.find_or_initialize_by(title: 'Real number')
@float_type.update(base_type: Seek::Samples::BaseType::FLOAT, placeholder: '0.5')

@date_type = SampleAttributeType.find_or_initialize_by(title: 'Date')
@date_type.update(base_type: Seek::Samples::BaseType::DATE, placeholder: 'January 1, 2015')

@string_type = SampleAttributeType.find_or_initialize_by(title: 'String')
@string_type.update(base_type: Seek::Samples::BaseType::STRING)

@cv_type = SampleAttributeType.find_or_initialize_by(title: 'Controlled Vocabulary')
@cv_type.update(base_type: Seek::Samples::BaseType::CV)

@text_type = SampleAttributeType.find_or_initialize_by(title: 'Text')
@text_type.update(base_type: Seek::Samples::BaseType::TEXT)

@link_type = SampleAttributeType.find_or_initialize_by(title: 'Web link')

@link_type.update(base_type: Seek::Samples::BaseType::STRING, regexp: URI.regexp(%w(http https)).to_s, placeholder: 'http://www.example.com', resolution: '\0')

@cv_list_type = SampleAttributeType.find_or_initialize_by(title:'Controlled Vocabulary List')
@cv_list_type.update(base_type: Seek::Samples::BaseType::CV_LIST)

def create_sample_controlled_vocab_terms_attributes(array)
  attributes = []
  array.each do |type|
    attributes << { label: type }
  end
  attributes
end
lang_array =["English","French","German",]
country_code_array = {"FR"=>"France","DE"=>"Germany","ES"=>"Spain","GB"=>"United Kingdom","US"=>"United States",}.values

disable_authorization_checks do

  # ************* Eligibility criteria: Minimum age ****************
  Design_eligibilityCriteria_ageMin_timeUnit_Investigation_cv = SampleControlledVocab.where(title: 'Design_eligibilityCriteria_ageMin_timeUnit_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Years', 'Months', 'Weeks', 'Days', 'Hours', 'Minutes', 'Weeks of gestation']))

  unless CustomMetadataType.where(title:'Design_eligibilityCriteria_ageMin_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_eligibilityCriteria_ageMin_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMin_number_Investigation', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Numerical value of the minimum age of potential participants eligible to participate in the Investigation.', label: 'Minimum eligible age(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMin_timeUnit_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_eligibilityCriteria_ageMin_timeUnit_Investigation_cv, description:'Unit of measurement used to describe the minimum eligible age.', label:'Unit of age(*)')
    cmt.save!
  end


  # ************* Eligibility criteria: Maximum age ****************
  Design_eligibilityCriteria_ageMax_timeUnit_Investigation_cv = SampleControlledVocab.where(title: 'Design_eligibilityCriteria_ageMax_timeUnit_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Years', 'Months', 'Weeks', 'Days', 'Hours', 'Minutes', 'Weeks of gestation']))

  unless CustomMetadataType.where(title:'Design_eligibilityCriteria_ageMax_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_eligibilityCriteria_ageMax_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMax_number_Investigation', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Numerical value of the maximum age of potential participants eligible to participate in the Investigation.', label: 'Maximum eligible age(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMax_timeUnit_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_eligibilityCriteria_ageMax_timeUnit_Investigation_cv, description:'Unit of measurement used to describe the maximum eligible age.', label:'Unit of age(*)')
    cmt.save!
  end


  # ************* Target follow-up duration of the [RESOURCE] ****************
  Design_nonInterventional_targetFollowUpDuration_timeUnit_Investigation_cv = SampleControlledVocab.where(title: 'Design_nonInterventional_targetFollowUpDuration_timeUnit_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Years', 'Months', 'Weeks', 'Days']))

  unless CustomMetadataType.where(title:'Design_nonInterventional_targetFollowUpDuration_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_nonInterventional_targetFollowUpDuration_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_nonInterventional_targetFollowUpDuration_number_Investigation', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Numerical value of the target follow-up duration.', label: 'Target follow-up duration(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_nonInterventional_targetFollowUpDuration_timeUnit_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_nonInterventional_targetFollowUpDuration_timeUnit_Investigation_cv, description:'Unit of time.', label:'Unit of time(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_nonInterventional_targetFollowUpDuration_frequency_Investigation', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'The number of follow-ups conducted within the specified duration.', label: 'How many follow-ups were conducted?')
    cmt.save!
  end


  # ************* Information about masking of intervention(s) assignment ****************
  Design_interventional_masking_roles_Investigation_cv = SampleControlledVocab.where(title: 'Design_interventional_masking_roles_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Participant', 'Care provider', 'Investigator', 'Outcomes assessor']))

  unless CustomMetadataType.where(title:'Design_interventional_masking_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_interventional_masking_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventional_masking_general_Investigation', sample_attribute_type: @bool_type, sample_controlled_vocab: nil, description: 'Indication, whether a masking (or blinding) of intervention(s) assignment is implemented (i.e., whether someone is prevented from having knowledge of the interventions assigned to individual participants).', label: 'Is masking of intervention(s) assignment implemented?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventional_masking_roles_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_interventional_masking_roles_Investigation_cv, description:'If masking is implemented, the party(ies) who are masked.', label:'Who is masked?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventional_masking_description_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If needed, additional descriptive information about masking (e.g. information about other parties who may be masked).', label: 'Additional information about masking')
    cmt.save!
  end


  # ************* Digital identifier(s) of the person ****************
  Resource_contributors_personal_identifiers_scheme_Investigation_cv = SampleControlledVocab.where(title: 'Resource_contributors_personal_identifiers_scheme_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['ORCID', 'ROR', 'GRID', 'ISNI']))

  unless CustomMetadataType.where(title:'Resource_contributors_personal_identifiers_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_contributors_personal_identifiers_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_personal_identifiers_identifier_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Digital identifier according to a specific scheme that uniquely identifies the person.', label: 'Identifier(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_personal_identifiers_scheme_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_personal_identifiers_scheme_Investigation_cv, description:'Type of the identifier scheme.', label:'Which type of identifier is reported?(*)')
    cmt.save!
  end


  # ************* Digital identifier(s) of the organisation ****************
  Resource_contributors_affiliations_identifiers_scheme_Investigation_cv = SampleControlledVocab.where(title: 'Resource_contributors_affiliations_identifiers_scheme_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['ROR', 'GRID', 'ISNI']))

  unless CustomMetadataType.where(title:'Resource_contributors_affiliations_identifiers_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_contributors_affiliations_identifiers_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_affiliations_identifiers_identifier_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Digital identifier according to a specific scheme that uniquely identifies the organisation.', label: 'Identifier(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_affiliations_identifiers_scheme_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_affiliations_identifiers_scheme_Investigation_cv, description:'Type of the identifier scheme.', label:'Identifier scheme(*)')
    cmt.save!
  end


  # ************* Eligibility criteria for [RESOURCE] participants ****************
  Design_eligibilityCriteria_genders_Investigation_cv = SampleControlledVocab.where(title: 'Design_eligibilityCriteria_genders_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Male', 'Female', 'Diverse', 'Not applicable']))

  unless CustomMetadataType.where(title:'Design_eligibilityCriteria_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_eligibilityCriteria_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMin_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_eligibilityCriteria_ageMin_Investigation', supported_type:'CustomMetadata').first, label: 'Eligibility criteria: Minimum age' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMax_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_eligibilityCriteria_ageMax_Investigation', supported_type:'CustomMetadata').first, label: 'Eligibility criteria: Maximum age' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_genders_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_eligibilityCriteria_genders_Investigation_cv, description:'Gender of potential participants eligible to participate in the Investigation.', label:'Eligible gender ')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_inclusionCriteria_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Inclusion criteria for participation in the Investigation.', label: 'Inclusion criteria')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_exclusionCriteria_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Exclusion criteria for participation in the Investigation. ', label: 'Exclusion criteria')
    cmt.save!
  end


  # ************* Population of the [RESOURCE] ****************
  Design_population_coverage_Investigation_cv = SampleControlledVocab.where(title: 'Design_population_coverage_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['International', 'National', 'Regional ']))

  Design_population_countries_Investigation_cv = SampleControlledVocab.where(title: 'Design_population_countries_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(country_code_array))

  unless CustomMetadataType.where(title:'Design_population_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_population_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_population_coverage_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_population_coverage_Investigation_cv, description:'Specification of the recruitment area of the Investigation ', label:'Coverage of the Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_population_countries_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_population_countries_Investigation_cv, description:'Country or countries where the Investigation takes place.', label:'Country(ies) where the Investigation takes place')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_population_region_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If applicable, region(s) and/or city(ies) within a country where the Investigation takes place.', label: 'Regions and/or cities within a country where the Investigation takes place')
    cmt.save!
  end


  # ************* Interventions of the [RESOURCE] ****************
  Design_interventions_type_Investigation_cv = SampleControlledVocab.where(title: 'Design_interventions_type_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Drug (including placebo)', 'Device (including sham)', 'Biological/Vaccine', 'Procedure/Surgery', 'Radiation', 'Behavioral (e.g., psychotherapy, lifestyle counseling)', 'Genetic (including gene transfer, stem cell and recombinant DNA)', 'Dietary supplement (e.g., vitamins, minerals)', 'Combination product (combining a drug and device, a biological product and device; a drug and biological product; or a drug, biological product, and device)', 'Diagnostic test (e.g., imaging, in-vitro)', 'Other']))

  unless CustomMetadataType.where(title:'Design_interventions_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_interventions_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventions_name_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'A short descriptive name of the intervention.', label: 'Name of the intervention(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventions_type_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_interventions_type_Investigation_cv, description:'General type of the given intervention.', label:'Type of the intervention')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventions_description_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If needed, additional descriptive information about the given intervention.', label: 'Additional information about the intervention')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventions_armsLabel_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of the Investigation arm(s) associated with the given intervention. ', label: 'Name of the arm(s) associated with the given intervention')
    cmt.save!
  end


  # ************* Exposures of the [RESOURCE] ****************
  Design_exposures_type_Investigation_cv = SampleControlledVocab.where(title: 'Design_exposures_type_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Drug (including placebo)', 'Device (including sham)', 'Biological/Vaccine', 'Procedure/Surgery', 'Radiation', 'Behavioral (e.g., psychotherapy, lifestyle counseling)', 'Genetic (including gene transfer, stem cell and recombinant DNA)', 'Dietary supplement (e.g., vitamins, minerals)', 'Combination product (combining a drug and device, a biological product and device; a drug and biological product; or a drug, biological product, and device)', 'Diagnostic test (e.g., imaging, in-vitro)', 'Other']))

  unless CustomMetadataType.where(title:'Design_exposures_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_exposures_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_exposures_name_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'A short descriptive name of the exposure.', label: 'Name of the exposure')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_exposures_type_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_exposures_type_Investigation_cv, description:'General type of the given exposure.', label:'Type of the exposure')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_exposures_description_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If needed, additional descriptive information about the given exposure.', label: 'Additional information about the exposure')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_exposures_groupsLabel_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of the Investigation group(s) associated with the given exposure. ', label: 'Name of the group(s) associated with the given exposure')
    cmt.save!
  end


  # ************* Outcome measure(s) ****************
  Design_outcomes_type_Investigation_cv = SampleControlledVocab.where(title: 'Design_outcomes_type_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Primary', 'Secondary', 'Other ']))

  unless CustomMetadataType.where(title:'Design_outcomes_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_outcomes_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_outcomes_title_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of the outcome measure.
For non-interventional studies, this can be the name of specific measurement(s) or observation(s) used to describe patterns of diseases or traits or associations with exposures, risk factors or treatment.', label: 'Name of the outcome measure(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_outcomes_description_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Additional descriptive information about the given outcome.', label: 'Description of the outcome measure')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_outcomes_type_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_outcomes_type_Investigation_cv, description:'Type of the outcome measure.', label:'Type of the outcome measure')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_outcomes_timeFrame_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Description of the time point(s) at which the measurement for the outcome is assessed, e.g. the specific duration of time over which each participant is assessed.', label: 'Time point(s) of assessment')
    cmt.save!
  end


  # ************* Information about data sharing ****************
  Design_dataSharingPlan_generally_Investigation_cv = SampleControlledVocab.where(title: 'Design_dataSharingPlan_generally_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes, there is a plan to make data available', 'No, there is no plan to make data available', 'Undecided, it is not yet known if data will be made available']))

  Design_dataSharingPlan_supportingInformation_Investigation_cv = SampleControlledVocab.where(title: 'Design_dataSharingPlan_supportingInformation_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Data dictionary', 'Study protocol', 'Protocol amendment', 'Statistical analysis plan', 'Analytic code', 'Informed consent form', 'Clinical study report', 'Manual of operations (SOP)', 'Case report form (template)', 'Questionnaire (template)', 'Code book', 'Other']))

  Design_dataSharingPlan_datashield_Investigation_cv = SampleControlledVocab.where(title: 'Design_dataSharingPlan_datashield_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes', 'No', 'Pending']))

  unless CustomMetadataType.where(title:'Design_dataSharingPlan_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_dataSharingPlan_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_generally_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_dataSharingPlan_generally_Investigation_cv, description:'Indication whether there is a plan to make data collected in the Investigation available. In case of a Investigation with patients or other individuals, this refers to individual participant data (IPD).', label:'Is it planned to share the data?(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_supportingInformation_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_dataSharingPlan_supportingInformation_Investigation_cv, description:'Supporting information/documents which will be made available in addition to the Investigation data.', label:'Supporting documents available in addition to the data')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_timeFrame_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Indication when the data and, if applicable, supporting documents will become available and for how long.', label: 'When and for how long will the data be available?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_accessCriteria_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Indication by what access criteria data will be shared, including:
a) with whom,
b) for what types of analyses, and
c) by what mechanism.', label: 'Criteria for the data access')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_description_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Additional descriptive information providing more details about the data sharing, e.g. indication what data in particular will be shared or why the data will not be shared or why it is not yet decided.', label: 'Additional information about data sharing')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_datashield_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_dataSharingPlan_datashield_Investigation_cv, description:'Indication, whether the DataSHIELD/Opal infrastructure is available.', label:'Is the DataSHIELD/Opal infrastructure available?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_url_Investigation', sample_attribute_type: @link_type, sample_controlled_vocab: nil, description: 'If existing, a link to the web page where additional information about data sharing can be found.', label: 'Web page with additional information about data sharing')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_recordLinkage_Investigation', sample_attribute_type: @bool_type, sample_controlled_vocab: nil, description: 'Indication if record linkage is possible.', label: 'Is record linkage with other data sources possible?')
    cmt.save!
  end


  # ************* Information about specific aspects of a non-interventional [RESOURCE] ****************
  Design_nonInterventional_timePerspectives_Investigation_cv = SampleControlledVocab.where(title: 'Design_nonInterventional_timePerspectives_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Retrospective', 'Prospective', 'Cross-sectional', 'Other']))

  Design_nonInterventional_biospecimenRetention_Investigation_cv = SampleControlledVocab.where(title: 'Design_nonInterventional_biospecimenRetention_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['None retained', 'Samples with DNA', 'Samples without DNA']))

  unless CustomMetadataType.where(title:'Design_nonInterventional_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_nonInterventional_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_nonInterventional_timePerspectives_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_nonInterventional_timePerspectives_Investigation_cv, description:'Temporal design of the Investigation, i.e. the  relationship of observation period to time of participant enrollment.', label:'Temporal design of the Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_nonInterventional_targetFollowUpDuration_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_nonInterventional_targetFollowUpDuration_Investigation', supported_type:'CustomMetadata').first, label: 'Target follow-up duration of the Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_nonInterventional_biospecimenRetention_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_nonInterventional_biospecimenRetention_Investigation_cv, description:'Indication whether samples of biomaterial from Investigation participants are retained in a biorepository.', label:'Which biosamples are retained in a biorepository?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_nonInterventional_biospecimenDescription_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Additional information about biosamples to be retained, i.e. which specific types of biospecimens will be retained (e.g. blood, serum, urine, etc.).', label: 'Specific types of retained biosamples')
    cmt.save!
  end


  # ************* Information about specific aspects of an interventional [RESOURCE] ****************
  Design_interventional_phase_Investigation_cv = SampleControlledVocab.where(title: 'Design_interventional_phase_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Early-phase-1', 'Phase-1', 'Phase-1-phase-2', 'Phase-2', 'Phase-2a', 'Phase-2b', 'Phase-2-phase-3', 'Phase-3', 'Phase-3a', 'Phase-3b', 'Phase-4', 'Other', 'Not applicable']))

  Design_interventional_allocation_Investigation_cv = SampleControlledVocab.where(title: 'Design_interventional_allocation_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Randomized', 'Nonrandomized', 'Not applicable (for single-arm trials)']))

  Design_interventional_offLabelUse_Investigation_cv = SampleControlledVocab.where(title: 'Design_interventional_offLabelUse_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes', 'No', 'Not applicable']))

  unless CustomMetadataType.where(title:'Design_interventional_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_interventional_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventional_phase_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_interventional_phase_Investigation_cv, description:'If applicable, numerical phase of the Investigation.', label:'Numerical phase of the Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventional_masking_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_interventional_masking_Investigation', supported_type:'CustomMetadata').first, label: 'Information about masking of intervention(s) assignment' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventional_allocation_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_interventional_allocation_Investigation_cv, description:'Type of allocation/assignment of individual Investigation participants to an arm.', label:'Type of allocation of participants to an arm')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventional_offLabelUse_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_interventional_offLabelUse_Investigation_cv, description:'Unapproved (off-label) use of a drug product. ', label:'Off-label use of a drug product')
    cmt.save!
  end


  # ************* Details about the organisation/institution/group/etc. ****************
  Resource_contributors_organisational_type_Investigation_cv = SampleControlledVocab.where(title: 'Resource_contributors_organisational_type_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Contact', 'Creator/Author', 'Funder (public)', 'Funder (private)', 'Sponsor (primary)', 'Sponsor (secondary)', 'Sponsor-Investigator', 'Research group', 'Data collector', 'Data curator', 'Data manager', 'Distributor', 'Hosting institution', 'Producer', 'Publisher', 'Registration agency', 'Registration authority', 'Rights holder', 'Supervisor', 'Other']))

  unless CustomMetadataType.where(title:'Resource_contributors_organisational_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_contributors_organisational_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_organisational_type_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_organisational_type_Investigation_cv, description:'Contributor type an organisation, institution or group fulllfils. For example, this can be a sponsor of the study or a group of authors of the document.', label:'Contributor type(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_organisational_fundingIds_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Identifier(s) assigned by a funder to the Investigation.', label: 'Funding identifier(s)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_organisational_name_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of the organisation, institution or group.', label: 'Name of the organisation/institution/group(*)')
    cmt.save!
  end


  # ************* Details about the person ****************
  Resource_contributors_personal_type_Investigation_cv = SampleControlledVocab.where(title: 'Resource_contributors_personal_type_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Contact', 'Principal investigator', 'Creator/Author', 'Sponsor (primary)', 'Sponsor (secondary)', 'Sponsor-Investigator', 'Data collector', 'Data curator', 'Data manager', 'Editor', 'Producer', 'Project leader', 'Project manager', 'Project member', 'Related person', 'Researcher', 'Rights holder', 'Supervisor', 'Work package leader', 'Other']))

  unless CustomMetadataType.where(title:'Resource_contributors_personal_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_contributors_personal_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_personal_type_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_personal_type_Investigation_cv, description:'Contributor type a person fulllfils. For example, this can be a principal investigator of a study or an author of a document.', label:'Contributor type(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_personal_givenName_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Given name of the person.', label: 'Given name of the person(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_personal_familyName_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Family name(s) of the person.', label: 'Family name(s) of the person(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_personal_identifiers_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata (multiple)').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_contributors_personal_identifiers_Investigation', supported_type:'CustomMetadata').first, label: 'Digital identifier(s) of the person' )
    cmt.save!
  end


  # ************* Further information about organisation(s) associated with the contributor ****************
  unless CustomMetadataType.where(title:'Resource_contributors_affiliations_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_contributors_affiliations_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_affiliations_name_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of the organisation associated with the contributor.', label: 'Name of the organisation(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_affiliations_address_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Address of the organisation associated with the contributor.', label: 'Address of the organisation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_affiliations_webpage_Investigation', sample_attribute_type: @link_type, sample_controlled_vocab: nil, description: 'Web page of the organisation associated with the contributor.', label: 'Web page of the organisation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_affiliations_identifiers_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata (multiple)').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_contributors_affiliations_identifiers_Investigation', supported_type:'CustomMetadata').first, label: 'Digital identifier(s) of the organisation' )
    cmt.save!
  end


  # ************* Specification of [RESOURCE] type ****************
  Design_studyType_interventional_Investigation_cv = SampleControlledVocab.where(title: 'Design_studyType_interventional_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Single group ', 'Parallel ', 'Crossover ', 'Factorial ', 'Sequential', 'Other', 'Unknown']))

  Design_studyType_nonInterventional_Investigation_cv = SampleControlledVocab.where(title: 'Design_studyType_nonInterventional_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Case-control', 'Nested case-control', 'Case-only', 'Case-crossover', 'Ecologic or community studies', 'Family-based', 'Twin study', 'Cohort', 'Case-cohort', 'Birth cohort', 'Trend', 'Panel', 'Longitudinal', 'Cross-sectional', 'Cross-sectional ad-hoc follow-up', 'Time series', 'Quality control', 'Register studies', 'Other', 'Unknown']))

  unless CustomMetadataType.where(title:'Design_studyType_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_studyType_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_studyType_interventional_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_studyType_interventional_Investigation_cv, description:'The strategy for assigning interventions to participants.', label:'Investigation type')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_studyType_nonInterventional_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_studyType_nonInterventional_Investigation_cv, description:'The primary strategy for participant identification and follow-up.', label:'Investigation type')
    cmt.save!
  end


  # ************* Primary health condition(s) or  disease(s) of the [RESOURCE] ****************
  Design_conditions_classification_Investigation_cv = SampleControlledVocab.where(title: 'Design_conditions_classification_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['MeSH', 'ICD-10', 'ICD-11', 'MedDRA', 'SNOMED CT', 'Other vocabulary', 'Free text']))

  unless CustomMetadataType.where(title:'Design_conditions_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_conditions_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_conditions_label_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of primary health condition or disease considered in the Investigation.', label: 'Name of the primary health condition or disease of the Investigation(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_conditions_classification_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_conditions_classification_Investigation_cv, description:'Terminology/classification used for the health condition or disease.', label:'Terminology/classification(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_conditions_code_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Code of the health condition or disease in the terminology/classification used.', label: 'Code ---- If known, code of the health condition or disease in the terminology/classification used')
    cmt.save!
  end


  # ************* Which groups of diseases or conditions were the data collected on? ****************
  Design_groupsOfDiseases_generally_Investigation_cv = SampleControlledVocab.where(title: 'Design_groupsOfDiseases_generally_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Certain infectious or parasitic diseases (I)', 'Neoplasms (II)', 'Diseases of the blood or blood-forming organs and certain disorders involving the immune mechanism (III)', 'Endocrine, nutritional and metabolic diseases (IV)', 'Mental and behavioural disorders (V)', 'Diseases of the nervous system (VI)', 'Diseases of the eye and adnexa (VII)', 'Diseases of the ear or mastoid process (VIII)', 'Diseases of the circulatory system (IX)', 'Diseases of the respiratory system (X)', 'Diseases of the digestive system (XI)', 'Diseases of the skin and subcutaneous tissue (XII)', 'Diseases of the musculoskeletal system and connective tissue (XIII)', 'Diseases of the genitourinary system (XIV)', 'Pregnancy, childbirth or the puerperium (XV)', 'Certain conditions originating in the perinatal period (XVI)', 'Congenital malformations, deformations and chromosomal abnormalities (XVII)', 'Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified (XVIII)', 'Injury, poisoning and certain other consequences of external causes (XIX)', 'External causes of morbidity or mortality (XX)', 'Factors influencing health status and contact with health services (XXI)', 'Other', 'Not applicable', 'Unknown']))

  unless CustomMetadataType.where(title:'Design_groupsOfDiseases_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_groupsOfDiseases_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_groupsOfDiseases_generally_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_groupsOfDiseases_generally_Investigation_cv, description:'Groups of diseases or conditions on which the data were collected in the Investigation.', label:'Which groups of diseases or conditions were the data collected on?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_groupsOfDiseases_conditions_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab:nil, description:'Other diseases or conditions on which the data were collected in the Investigation.', label:'On which other diseases or conditions were the data collected?')
    cmt.save!
  end


  # ************* Administrative information ****************
  Design_administrativeInformation_ethicsCommitteeApproval_Investigation_cv = SampleControlledVocab.where(title: 'Design_administrativeInformation_ethicsCommitteeApproval_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Request for approval not yet submitted', 'Request for approval submitted, approval pending', 'Request for approval submitted, approval granted', 'Request for approval submitted, exempt granted', 'Request for approval submitted, approval denied', 'Approval not required', 'Study withdrawn prior to decision on approval', 'Unknown status of request approval']))

  Design_administrativeInformation_status_Investigation_cv = SampleControlledVocab.where(title: 'Design_administrativeInformation_status_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['At the planning stage', 'Ongoing (I): Recruitment ongoing, but data collection not yet started', 'Ongoing (II): Recruitment and data collection ongoing', 'Ongoing (III): Recruitment completed, but data collection ongoing', 'Ongoing (IV): Recruitment and data collection completed, but data quality management ongoing', 'Suspended: Recruitment, data collection, or data quality management, halted, but potentially will resume', 'Terminated: Recruitment, data collection, data and quality management halted prematurely and will not resume', 'Completed: Recruitment, data collection, and data quality management completed normally', 'Other']))

  Design_administrativeInformation_statusEnrollingByInvitation_Investigation_cv = SampleControlledVocab.where(title: 'Design_administrativeInformation_statusEnrollingByInvitation_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes', 'No', 'Not applicable']))

  unless CustomMetadataType.where(title:'Design_administrativeInformation_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_administrativeInformation_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_administrativeInformation_ethicsCommitteeApproval_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_administrativeInformation_ethicsCommitteeApproval_Investigation_cv, description:'Status of the Investigation approval from the (leading) ethics committee.', label:'Status of the ethics committee approval')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_administrativeInformation_status_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_administrativeInformation_status_Investigation_cv, description:'Overall status of the Investigation.', label:'Overall Investigation status')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_administrativeInformation_statusEnrollingByInvitation_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_administrativeInformation_statusEnrollingByInvitation_Investigation_cv, description:'Specification whether Investigation participants have been selected from a predetermined population.', label:'Are participants enrolled by invitation?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_administrativeInformation_startDate_Investigation', sample_attribute_type: @date_type, sample_controlled_vocab: nil, description: 'Start date of data collection for the Investigation.', label: 'Start date of data collection for the Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_administrativeInformation_endDate_Investigation', sample_attribute_type: @date_type, sample_controlled_vocab: nil, description: 'In case of a Investigation with patients or other participants, it is the date when the last participant is examined or receives an intervention, or the date of the last participants last visit.', label: 'End date of data collection for the Investigation')
    cmt.save!
  end


  # ************* Contributor(s) ****************
  Resource_contributors_nameType_Investigation_cv = SampleControlledVocab.where(title: 'Resource_contributors_nameType_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Personal', 'Organisational']))

  unless CustomMetadataType.where(title:'Resource_contributors_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_contributors_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_nameType_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_nameType_Investigation_cv, description:'Personal or organisational/group contribution.', label:'Is it a personal or organisational contribution?(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_organisational_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata (multiple)').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_contributors_organisational_Investigation', supported_type:'CustomMetadata').first, label: 'Details about the organisation/institution/group/etc.' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_personal_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata (multiple)').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_contributors_personal_Investigation', supported_type:'CustomMetadata').first, label: 'Details about the person' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_email_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Email address of the  person, group of persons or institution/organisation.', label: 'Email address')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_phone_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Phone number of the  person, group of persons or institution/organisation.', label: 'Phone number')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_affiliations_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata (multiple)').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_contributors_affiliations_Investigation', supported_type:'CustomMetadata').first, label: 'Further information about organisation(s) associated with the contributor' )
    cmt.save!
  end


  # ************* Alternative identifiers ****************
  Resource_idsAlternative_scheme_Investigation_cv = SampleControlledVocab.where(title: 'Resource_idsAlternative_scheme_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['DRKS', 'NCT (ClinicalTrials.gov)', 'ISRCTN', 'EudraCT', 'EUDAMED', 'UTN', 'KonsortSWD', 'MDM Portal', 'Other']))

  unless CustomMetadataType.where(title:'Resource_idsAlternative_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_idsAlternative_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_idsAlternative_scheme_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_idsAlternative_scheme_Investigation_cv, description:'Type/name of the system where the given Investigation is already registered.', label:'Type of the registry(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_idsAlternative_identifier_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Identifier (ID) assigned to the given Investigation by another registering system, e.g. by a registry of clinical trials or a data repository.', label: 'Identifier(*)')
    cmt.save!
  end


  # ************* Characteristics of the [RESOURCE] ****************
  Design_mortalityData_Investigation_cv = SampleControlledVocab.where(title: 'Design_mortalityData_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes, vital status only (cause of death missing) ', 'Yes, with cause of death ', 'No']))

  Design_centers_Investigation_cv = SampleControlledVocab.where(title: 'Design_centers_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Monocentric', 'Multicentric']))

  Design_dataProviders_Investigation_cv = SampleControlledVocab.where(title: 'Design_dataProviders_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['One data provider', 'Several data providers']))

  Design_subject_Investigation_cv = SampleControlledVocab.where(title: 'Design_subject_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Person', 'Animal', 'Other', 'Unknown']))

  Design_assessments_Investigation_cv = SampleControlledVocab.where(title: 'Design_assessments_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Diet/Nutrition', 'Physical activity', 'Tobacco use', 'Alcohol consumption', 'Body weight', 'Body height', 'Waist circumference ', 'Body Mass Index ', 'Body fat percentage', 'Sociodemographic information']))

  unless CustomMetadataType.where(title:'Design_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Design_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_studyType_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_studyType_Investigation', supported_type:'CustomMetadata').first, label: 'Specification of Investigation type' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_conditions_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_conditions_Investigation', supported_type:'CustomMetadata').first, label: 'Primary health condition(s) or  disease(s) of the Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_groupsOfDiseases_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_groupsOfDiseases_Investigation', supported_type:'CustomMetadata').first, label: 'Which groups of diseases or conditions were the data collected on?(*)' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_mortalityData_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_mortalityData_Investigation_cv, description:'Mortality data.', label:'Were mortality data collected?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_administrativeInformation_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_administrativeInformation_Investigation', supported_type:'CustomMetadata').first, label: 'Administrative information' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_centers_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_centers_Investigation_cv, description:'Specification whether a Investigation is conducted at one Investigation center or at more than one Investigation center.', label:'Is it a mono- or multicentric Investigation?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_centersNumber_Investigation', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Number of centers involved in the Investigation.', label: 'Number of Investigation centers')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataProviders_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_dataProviders_Investigation_cv, description:'Specification whether this Investigation is occuring from one data provider or at more than one data provider.', label:'Is this Investigation occurring from one or more data providers?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataProvidersNumber_Investigation', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Number of data providers involved in the Investigation.', label: 'Number of Investigation data providers')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_subject_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_subject_Investigation_cv, description:'Primary Investigation subject, i.e. a person, an animal or some other type of the subject.', label:'Primary Investigation subject (*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_eligibilityCriteria_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_eligibilityCriteria_Investigation', supported_type:'CustomMetadata').first, label: 'Eligibility criteria for Investigation participants' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_population_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_population_Investigation', supported_type:'CustomMetadata').first, label: 'Population of the Investigation(*)' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventions_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_interventions_Investigation', supported_type:'CustomMetadata').first, label: 'Interventions of the Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_exposures_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_exposures_Investigation', supported_type:'CustomMetadata').first, label: 'Exposures of the Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_outcomes_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_outcomes_Investigation', supported_type:'CustomMetadata').first, label: 'Outcome measure(s)' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_comment_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Any additional information about specific aspects of the Investigation that cannot be captured by other fields.', label: 'Any additional information about the Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_assessments_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_assessments_Investigation_cv, description:'Assessments/measurements included in the Investigation.', label:'Further assessments/measurements included in the Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_dataSharingPlan_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_dataSharingPlan_Investigation', supported_type:'CustomMetadata').first, label: 'Information about data sharing(*)' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_nonInterventional_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_nonInterventional_Investigation', supported_type:'CustomMetadata').first, label: 'Information about specific aspects of a non-interventional Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_interventional_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_interventional_Investigation', supported_type:'CustomMetadata').first, label: 'Information about specific aspects of an interventional Investigation' )
    cmt.save!
  end


  # ************* Classification of the resource within the predefined categories ****************
  Resource_classification_type_Investigation_cv = SampleControlledVocab.where(title: 'Resource_classification_type_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Study', 'Substudy/Data collection event', 'Biobank', 'Case report form', 'Code book', 'Data dictionary', 'Data management plan', 'Dataset', 'Discussion guide', 'Informed consent form', 'Interview scheme and themes', 'Manual of operations (SOPs)', 'Observation guide', 'Participant tasks', 'Patient information sheet', 'Questionnaire', 'Registry', 'Secondary data source', 'Statistical analysis plan', 'Study protocol', 'Other data collection instrument', 'Other study document', 'Other']))

  unless CustomMetadataType.where(title:'Resource_classification_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_classification_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_classification_type_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_classification_type_Investigation_cv, description:'A term describing the Investigation.', label:'Type of the Investigation(*)')
    cmt.save!
  end


  # ************* Title(s)/name(s) of the [RESOURCE] ****************
  Resource_titles_language_Investigation_cv = SampleControlledVocab.where(title: 'Resource_titles_language_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(lang_array))

  unless CustomMetadataType.where(title:'Resource_titles_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_titles_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_titles_text_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Scientific unabbreviated title or name of the Investigation.  ', label: 'Title/name(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_titles_language_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_titles_language_Investigation_cv, description:'Language of the title/name.', label:'Language of the title/name(*)')
    cmt.save!
  end


  # ************* Acronym(s) of the [RESOURCE] ****************
  Resource_acronyms_language_Investigation_cv = SampleControlledVocab.where(title: 'Resource_acronyms_language_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(lang_array))

  unless CustomMetadataType.where(title:'Resource_acronyms_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_acronyms_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_acronyms_text_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If existing, acronym(s) of the Investigation.', label: 'Acronym(*)')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_acronyms_language_Investigation', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_acronyms_language_Investigation_cv, description:'Language of the acronym.', label:'Language of the acronym(*)')
    cmt.save!
  end


  # ************* Description(s) of the [RESOURCE] ****************
  unless CustomMetadataType.where(title:'Resource_descriptions_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_descriptions_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_descriptions_text_Investigation', sample_attribute_type: @text_type, sample_controlled_vocab: nil, description: 'Short plain text summary of the Investigation. ', label: 'Description(*)')
    cmt.save!
  end


  # ************* Keyword(s) describing the  [RESOURCE] ****************
  unless CustomMetadataType.where(title:'Resource_keywords_Investigation', supported_type:'CustomMetadata').any?
    cmt = CustomMetadataType.new(title: 'Resource_keywords_Investigation', supported_type:'CustomMetadata')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_keywords_label_Investigation', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Keyword(s) describing the Investigation.', label: 'Keyword(*)')
    cmt.save!
  end


  # ************* Resource ****************
  Resource_languages_Investigation_cv = SampleControlledVocab.where(title: 'Resource_languages_Investigation').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(lang_array))

  unless CustomMetadataType.where(title:'Nfdi4Health MDS 3.2', supported_type:'Investigation').any?
    cmt = CustomMetadataType.new(title: 'Nfdi4Health MDS 3.2', supported_type:'Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_classification_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_classification_Investigation', supported_type:'CustomMetadata').first, label: 'Classification of the resource within the predefined categories(*)' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_titles_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_titles_Investigation', supported_type:'CustomMetadata').first, label: 'Title(s)/name(s) of the Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_acronyms_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_acronyms_Investigation', supported_type:'CustomMetadata').first, label: 'Acronym(s) of the Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_descriptions_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_descriptions_Investigation', supported_type:'CustomMetadata').first, label: 'Description(s) of the Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_keywords_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata (multiple)').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_keywords_Investigation', supported_type:'CustomMetadata').first, label: 'Keyword(s) describing the  Investigation' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_languages_Investigation', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Resource_languages_Investigation_cv, description:'Language(s) in which the   Investigation is conducted/provided.', label:'Language(s) of the Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_webpage_Investigation', sample_attribute_type: @link_type, sample_controlled_vocab: nil, description: 'If existing, a link to the web page directly relevant to the  Investigation.', label: 'Web page of the Investigation')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_contributors_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_contributors_Investigation', supported_type:'CustomMetadata').first, label: 'Contributor(s)' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_idsAlternative_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata (multiple)').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Resource_idsAlternative_Investigation', supported_type:'CustomMetadata').first, label: 'Alternative identifiers' )
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_nutritionalData_Investigation', sample_attribute_type: @bool_type, sample_controlled_vocab: nil, description: 'Indication whether nutritional data was collected by the Investigation.', label: 'Nutritional data collected?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Resource_chronicDiseases_Investigation', sample_attribute_type: @bool_type, sample_controlled_vocab: nil, description: 'Indication whether chronic diseases were addressed by the Investigation.', label: 'Chronic diseases included?')
    cmt.custom_metadata_attributes << CustomMetadataAttribute.new(title: 'Design_Investigation', sample_attribute_type: SampleAttributeType.where(title:'Linked Custom Metadata').first , linked_custom_metadata_type: CustomMetadataType.where(title:'Design_Investigation', supported_type:'CustomMetadata').first, label: 'Characteristics of the Investigation' )
    cmt.save!
  end

puts '... Done!'
end
