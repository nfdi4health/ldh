#!/bin/env ruby
# encoding: utf-8
puts 'Seeding NFDI4Health MDS 3.3 to Project Extended Metadata ...'

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
  Design_eligibilityCriteria_ageMin_timeUnit_Project_cv = SampleControlledVocab.where(title: 'Design_eligibilityCriteria_ageMin_timeUnit_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Years', 'Months', 'Weeks', 'Days', 'Hours', 'Minutes', 'Weeks of gestation']))

  unless ExtendedMetadataType.where(title:'Design_eligibilityCriteria_ageMin_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_eligibilityCriteria_ageMin_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMin_number_Project', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Numerical value of the minimum age of potential participants eligible to participate in the Project.', label: 'Minimum eligible age(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMin_timeUnit_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_eligibilityCriteria_ageMin_timeUnit_Project_cv, description:'Unit of measurement used to describe the minimum eligible age.', label:'Unit of age(*)')
    emt.save!
  end


  # ************* Eligibility criteria: Maximum age ****************
  Design_eligibilityCriteria_ageMax_timeUnit_Project_cv = SampleControlledVocab.where(title: 'Design_eligibilityCriteria_ageMax_timeUnit_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Years', 'Months', 'Weeks', 'Days', 'Hours', 'Minutes', 'Weeks of gestation']))

  unless ExtendedMetadataType.where(title:'Design_eligibilityCriteria_ageMax_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_eligibilityCriteria_ageMax_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMax_number_Project', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Numerical value of the maximum age of potential participants eligible to participate in the Project.', label: 'Maximum eligible age(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMax_timeUnit_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_eligibilityCriteria_ageMax_timeUnit_Project_cv, description:'Unit of measurement used to describe the maximum eligible age.', label:'Unit of age(*)')
    emt.save!
  end


  # ************* Target follow-up duration of the [RESOURCE] ****************
  Design_nonInterventional_targetFollowUpDuration_timeUnit_Project_cv = SampleControlledVocab.where(title: 'Design_nonInterventional_targetFollowUpDuration_timeUnit_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Years', 'Months', 'Weeks', 'Days']))

  unless ExtendedMetadataType.where(title:'Design_nonInterventional_targetFollowUpDuration_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_nonInterventional_targetFollowUpDuration_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_nonInterventional_targetFollowUpDuration_number_Project', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Numerical value of the target follow-up duration.', label: 'Target follow-up duration(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_nonInterventional_targetFollowUpDuration_timeUnit_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_nonInterventional_targetFollowUpDuration_timeUnit_Project_cv, description:'Unit of measurement used to describe the follow-up duration.', label:'Unit of time(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_nonInterventional_targetFollowUpDuration_frequency_Project', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'The number of follow-ups conducted within the specified duration.', label: 'Number of follow-ups conducted')
    emt.save!
  end


  # ************* Masking of intervention(s) assignment ****************
  Design_interventional_masking_roles_Project_cv = SampleControlledVocab.where(title: 'Design_interventional_masking_roles_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Participant', 'Care provider', 'Investigator', 'Outcomes assessor']))

  unless ExtendedMetadataType.where(title:'Design_interventional_masking_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_interventional_masking_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventional_masking_general_Project', sample_attribute_type: @bool_type, sample_controlled_vocab: nil, description: 'Indication whether a masking (or blinding) of intervention(s) assignment is implemented (i.e., whether someone is prevented from having knowledge of the interventions assigned to individual participants).', label: 'Masking implemented?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventional_masking_roles_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_interventional_masking_roles_Project_cv, description:'If masking is implemented, the party(ies) who are masked.', label:'Who is masked?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventional_masking_description_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If needed, additional descriptive information about masking (e.g. information about other parties who may be masked).', label: 'Additional information about masking')
    emt.save!
  end


  # ************* Digital identifier(s) ****************
  Resource_contributors_personal_identifiers_scheme_Project_cv = SampleControlledVocab.where(title: 'Resource_contributors_personal_identifiers_scheme_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['ORCID', 'ROR', 'GRID', 'ISNI']))

  unless ExtendedMetadataType.where(title:'Resource_contributors_personal_identifiers_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_contributors_personal_identifiers_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_personal_identifiers_identifier_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Digital identifier according to a specific scheme that uniquely identifies the person.', label: 'Identifier(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_personal_identifiers_scheme_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_personal_identifiers_scheme_Project_cv, description:'Type of the identifier scheme reported.', label:'Scheme(*)')
    emt.save!
  end


  # ************* Digital identifier(s) ****************
  Resource_contributors_affiliations_identifiers_scheme_Project_cv = SampleControlledVocab.where(title: 'Resource_contributors_affiliations_identifiers_scheme_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['ROR', 'GRID', 'ISNI']))

  unless ExtendedMetadataType.where(title:'Resource_contributors_affiliations_identifiers_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_contributors_affiliations_identifiers_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_affiliations_identifiers_identifier_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Digital identifier according to a specific scheme that uniquely identifies the organisation.', label: 'Identifier(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_affiliations_identifiers_scheme_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_affiliations_identifiers_scheme_Project_cv, description:'Type of the identifier scheme reported.', label:'Scheme(*)')
    emt.save!
  end


  # ************* Eligibility criteria for [RESOURCE] participants ****************
  Design_eligibilityCriteria_genders_Project_cv = SampleControlledVocab.where(title: 'Design_eligibilityCriteria_genders_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Male', 'Female', 'Diverse', 'Not applicable']))

  unless ExtendedMetadataType.where(title:'Design_eligibilityCriteria_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_eligibilityCriteria_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMin_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_eligibilityCriteria_ageMin_Project', supported_type:'ExtendedMetadata').first, label: 'Eligibility criteria: Minimum age' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_ageMax_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_eligibilityCriteria_ageMax_Project', supported_type:'ExtendedMetadata').first, label: 'Eligibility criteria: Maximum age' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_genders_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_eligibilityCriteria_genders_Project_cv, description:'Gender of potential participants eligible to participate in the Project.', label:'Eligible gender')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_inclusionCriteria_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Inclusion criteria for participation in the Project.', label: 'Inclusion criteria')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_exclusionCriteria_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Exclusion criteria for participation in the Project.', label: 'Exclusion criteria')
    emt.save!
  end


  # ************* Population of the [RESOURCE] ****************
  Design_population_coverage_Project_cv = SampleControlledVocab.where(title: 'Design_population_coverage_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['International', 'National', 'Regional']))

  Design_population_countries_Project_cv = SampleControlledVocab.where(title: 'Design_population_countries_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(country_code_array))

  unless ExtendedMetadataType.where(title:'Design_population_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_population_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_population_coverage_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_population_coverage_Project_cv, description:'Specification of the recruitment area of the Project.', label:'Coverage')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_population_countries_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_population_countries_Project_cv, description:'Country or countries where the Project takes place.', label:'Country(ies)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_population_region_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If applicable, region(s) and/or city(ies) within a country where the Project takes place.', label: 'Region(s) and/or city(ies)')
    emt.save!
  end


  # ************* Interventions of the [RESOURCE] ****************
  Design_interventions_type_Project_cv = SampleControlledVocab.where(title: 'Design_interventions_type_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Drug (including placebo)', 'Device (including sham)', 'Biological/Vaccine', 'Procedure/Surgery', 'Radiation', 'Behavioral (e.g., psychotherapy, lifestyle counseling)', 'Genetic (including gene transfer, stem cell and recombinant DNA)', 'Dietary supplement (e.g., vitamins, minerals)', 'Combination product (combining a drug and device, a biological product and device; a drug and biological product; or a drug, biological product, and device)', 'Diagnostic test (e.g., imaging, in-vitro)', 'Other']))

  unless ExtendedMetadataType.where(title:'Design_interventions_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_interventions_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventions_name_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'A short descriptive name of the intervention.', label: 'Name of the intervention(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventions_type_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_interventions_type_Project_cv, description:'General type of the given intervention.', label:'Type of the intervention')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventions_description_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If needed, additional descriptive information about the given intervention.', label: 'Additional information about the intervention')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventions_armsLabel_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name(s) of the Project arm(s) associated with the given intervention.', label: 'Name(s) of the arm(s) associated with the given intervention')
    emt.save!
  end


  # ************* Exposures of the [RESOURCE] ****************
  Design_exposures_type_Project_cv = SampleControlledVocab.where(title: 'Design_exposures_type_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Drug (including placebo)', 'Device (including sham)', 'Biological/Vaccine', 'Procedure/Surgery', 'Radiation', 'Behavioral (e.g., psychotherapy, lifestyle counseling)', 'Genetic (including gene transfer, stem cell and recombinant DNA)', 'Dietary supplement (e.g., vitamins, minerals)', 'Combination product (combining a drug and device, a biological product and device; a drug and biological product; or a drug, biological product, and device)', 'Diagnostic test (e.g., imaging, in-vitro)', 'Other']))

  unless ExtendedMetadataType.where(title:'Design_exposures_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_exposures_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_exposures_name_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'A short descriptive name of the exposure.', label: 'Name of the exposure')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_exposures_type_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_exposures_type_Project_cv, description:'General type of the given exposure.', label:'Type of the exposure')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_exposures_description_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If needed, additional descriptive information about the given exposure.', label: 'Additional information about the exposure')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_exposures_groupsLabel_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name(s) of the Project group(s) associated with the given exposure.', label: 'Name(s) of the group(s) associated with the given exposure')
    emt.save!
  end


  # ************* Outcome measures in the [RESOURCE] ****************
  Design_outcomes_type_Project_cv = SampleControlledVocab.where(title: 'Design_outcomes_type_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Primary', 'Secondary', 'Other ']))

  unless ExtendedMetadataType.where(title:'Design_outcomes_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_outcomes_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_outcomes_title_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of the outcome measure.
For non-interventional studies, this can be the name of specific measurement(s) or observation(s) used to describe patterns of diseases or traits or associations with exposures, risk factors or treatment.', label: 'Name of the outcome measure(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_outcomes_description_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Additional descriptive information about the given outcome.', label: 'Description of the outcome measure')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_outcomes_type_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_outcomes_type_Project_cv, description:'The type indicates the degree of importance of the outcome measure in the Project.', label:'Type of the outcome measure')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_outcomes_timeFrame_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Description of the time point(s) at which the measurement for the outcome is assessed, e.g. the specific duration of time over which each participant is assessed.', label: 'Time point(s) of assessment')
    emt.save!
  end


  # ************* Data sharing strategy of the [RESOURCE] ****************
  Design_dataSharingPlan_generally_Project_cv = SampleControlledVocab.where(title: 'Design_dataSharingPlan_generally_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes, there is a plan to make data available', 'No, there is no plan to make data available', 'Undecided, it is not yet known if data will be made available']))

  Design_dataSharingPlan_supportingInformation_Project_cv = SampleControlledVocab.where(title: 'Design_dataSharingPlan_supportingInformation_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Data dictionary', 'Study protocol', 'Protocol amendment', 'Statistical analysis plan', 'Analytic code', 'Informed consent form', 'Clinical study report', 'Manual of operations (SOP)', 'Case report form (template)', 'Questionnaire (template)', 'Code book', 'Other']))

  Design_dataSharingPlan_datashield_Project_cv = SampleControlledVocab.where(title: 'Design_dataSharingPlan_datashield_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes', 'No', 'Pending']))

  unless ExtendedMetadataType.where(title:'Design_dataSharingPlan_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_dataSharingPlan_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_generally_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_dataSharingPlan_generally_Project_cv, description:'Indication whether there is a plan to make data collected in the Project available. In case of a Project with patients or other individuals, this refers to individual participant data (IPD).', label:'Is it planned to share the data?(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_supportingInformation_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_dataSharingPlan_supportingInformation_Project_cv, description:'Supporting information/documents which will be made available in addition to the data collected in the Project.', label:'Supporting documents available in addition to the data')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_timeFrame_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Indication of the time period for which the data and, if applicable, supporting documents will be made available.', label: 'When and for how long will the data be available?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_accessCriteria_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Indication of the access criteria by which the data will be shared, including: a) with whom; b) for which types of analyses; and c) by what mechanism.', label: 'Criteria for data access')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_description_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Additional descriptive information providing more details about data sharing, e.g. indication of which data in particular will be shared or why the data will not be shared or why it is not yet decided.', label: 'Additional information about data sharing')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_datashield_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_dataSharingPlan_datashield_Project_cv, description:'Indication whether the DataSHIELD/Opal infrastructure is available.', label:'DataSHIELD/Opal infrastructure available?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_requestData_Project', sample_attribute_type: @link_type, sample_controlled_vocab: nil, description: 'If existing, a link to the web page where the data request form and/or information on data reuse can be found.', label: 'Link to data request application')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_url_Project', sample_attribute_type: @link_type, sample_controlled_vocab: nil, description: 'If existing, a link to the web page where additional information about data sharing can be found.', label: 'Web page with additional information about data sharing')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_recordLinkage_Project', sample_attribute_type: @bool_type, sample_controlled_vocab: nil, description: 'Indication if record linkage with other data sources is possible.', label: 'Record linkage possible?')
    emt.save!
  end


  # ************* Non-interventional aspects of the [RESOURCE] ****************
  Design_nonInterventional_timePerspectives_Project_cv = SampleControlledVocab.where(title: 'Design_nonInterventional_timePerspectives_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Retrospective', 'Prospective', 'Cross-sectional', 'Other']))

  Design_nonInterventional_biospecimenRetention_Project_cv = SampleControlledVocab.where(title: 'Design_nonInterventional_biospecimenRetention_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['None retained', 'Samples with DNA', 'Samples without DNA']))

  unless ExtendedMetadataType.where(title:'Design_nonInterventional_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_nonInterventional_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_nonInterventional_timePerspectives_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_nonInterventional_timePerspectives_Project_cv, description:'Temporal design of the Project, i.e. the observation period in relation to the time of participant enrollment.', label:'Temporal design')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_nonInterventional_targetFollowUpDuration_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_nonInterventional_targetFollowUpDuration_Project', supported_type:'ExtendedMetadata').first, label: 'Target follow-up duration of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_nonInterventional_biospecimenRetention_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_nonInterventional_biospecimenRetention_Project_cv, description:'Indication whether samples of biomaterials from participants of the Project are retained in a biorepository.', label:'Biosamples retained in a biorepository')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_nonInterventional_biospecimenDescription_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Additional information about retained biosamples, i.e. an indication of the specific types of retained biospecimens (e.g. blood, serum, urine, etc.).', label: 'Specific types of retained biosamples')
    emt.save!
  end


  # ************* Interventional aspects of the [RESOURCE] ****************
  Design_interventional_phase_Project_cv = SampleControlledVocab.where(title: 'Design_interventional_phase_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Early-phase-1', 'Phase-1', 'Phase-1-phase-2', 'Phase-2', 'Phase-2a', 'Phase-2b', 'Phase-2-phase-3', 'Phase-3', 'Phase-3a', 'Phase-3b', 'Phase-4', 'Other', 'Not applicable']))

  Design_interventional_allocation_Project_cv = SampleControlledVocab.where(title: 'Design_interventional_allocation_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Randomized', 'Nonrandomized', 'Not applicable (for single-arm trials)']))

  Design_interventional_offLabelUse_Project_cv = SampleControlledVocab.where(title: 'Design_interventional_offLabelUse_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes', 'No', 'Not applicable']))

  unless ExtendedMetadataType.where(title:'Design_interventional_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_interventional_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventional_phase_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_interventional_phase_Project_cv, description:'If applicable, numerical phase of the Project.', label:'Numerical phase')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventional_masking_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_interventional_masking_Project', supported_type:'ExtendedMetadata').first, label: 'Masking of intervention(s) assignment' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventional_allocation_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_interventional_allocation_Project_cv, description:'Type of allocation/assignment of individual participants of the Project to an arm.', label:'Type of allocation of participants to an arm')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventional_offLabelUse_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_interventional_offLabelUse_Project_cv, description:'Unapproved (off-label) use of a drug product.', label:'Off-label use of a drug product')
    emt.save!
  end


  # ************* Details about the contributing organisation(s)/institution(s)/group(s) ****************
  Resource_contributors_organisational_type_Project_cv = SampleControlledVocab.where(title: 'Resource_contributors_organisational_type_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Contact', 'Creator/Author', 'Funder (public)', 'Funder (private)', 'Sponsor (primary)', 'Sponsor (secondary)', 'Sponsor-Investigator', 'Research group', 'Data collector', 'Data curator', 'Data manager', 'Distributor', 'Hosting institution', 'Producer', 'Publisher', 'Registration agency', 'Registration authority', 'Rights holder', 'Supervisor', 'Other']))

  unless ExtendedMetadataType.where(title:'Resource_contributors_organisational_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_contributors_organisational_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_organisational_type_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_organisational_type_Project_cv, description:'Contributor type an organisation, institution or group fulfills. For example, this can be a sponsor of the study or a group of authors of the document.', label:'Contributor type(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_organisational_fundingIds_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Identifier(s) assigned by a funder to the Project.', label: 'Funding identifier(s)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_organisational_name_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of the organisation, institution or group.', label: 'Name of the organisation/institution/group(*)')
    emt.save!
  end


  # ************* Details about the contributing person(s) ****************
  Resource_contributors_personal_type_Project_cv = SampleControlledVocab.where(title: 'Resource_contributors_personal_type_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Contact', 'Principal investigator', 'Creator/Author', 'Sponsor (primary)', 'Sponsor (secondary)', 'Sponsor-Investigator', 'Data collector', 'Data curator', 'Data manager', 'Editor', 'Producer', 'Project leader', 'Project manager', 'Project member', 'Related person', 'Researcher', 'Rights holder', 'Supervisor', 'Work package leader', 'Other']))

  unless ExtendedMetadataType.where(title:'Resource_contributors_personal_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_contributors_personal_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_personal_type_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_personal_type_Project_cv, description:'Contributor type a person fulfills. For example, this can be a principal investigator of a study or an author of a document.', label:'Contributor type(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_personal_givenName_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Given name of the person.', label: 'Given name(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_personal_familyName_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Family name(s) of the person.', label: 'Family name(s)(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_personal_identifiers_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_contributors_personal_identifiers_Project', supported_type:'ExtendedMetadata').first, label: 'Digital identifier(s)' )
    emt.save!
  end


  # ************* Organisation(s) associated with the contributor ****************
  unless ExtendedMetadataType.where(title:'Resource_contributors_affiliations_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_contributors_affiliations_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_affiliations_name_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of the organisation associated with the contributor.', label: 'Name(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_affiliations_address_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Address of the organisation associated with the contributor.', label: 'Address')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_affiliations_webpage_Project', sample_attribute_type: @link_type, sample_controlled_vocab: nil, description: 'Web page of the organisation associated with the contributor.', label: 'Web page')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_affiliations_identifiers_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_contributors_affiliations_identifiers_Project', supported_type:'ExtendedMetadata').first, label: 'Digital identifier(s)' )
    emt.save!
  end


  # ************* Specification of the type of the [RESOURCE] ****************
  Design_studyType_interventional_Project_cv = SampleControlledVocab.where(title: 'Design_studyType_interventional_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Single group', 'Parallel', 'Crossover', 'Factorial', 'Sequential', 'Other', 'Unknown']))

  Design_studyType_nonInterventional_Project_cv = SampleControlledVocab.where(title: 'Design_studyType_nonInterventional_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Case-control', 'Nested case-control', 'Case-only', 'Case-crossover', 'Ecologic or community studies', 'Family-based', 'Twin study', 'Cohort', 'Case-cohort', 'Birth cohort', 'Trend', 'Panel', 'Longitudinal', 'Cross-sectional', 'Cross-sectional ad-hoc follow-up', 'Time series', 'Quality control', 'Register studies', 'Other', 'Unknown']))

  unless ExtendedMetadataType.where(title:'Design_studyType_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_studyType_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_studyType_interventional_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_studyType_interventional_Project_cv, description:'The strategy for assigning interventions to participants.', label:'Interventional Project type')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_studyType_nonInterventional_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_studyType_nonInterventional_Project_cv, description:'The primary strategy for participant identification and follow-up.', label:'Non-interventional Project type')
    emt.save!
  end


  # ************* Primary health condition(s) or disease(s) considered in the [RESOURCE] ****************
  Design_conditions_classification_Project_cv = SampleControlledVocab.where(title: 'Design_conditions_classification_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['MeSH', 'ICD-10', 'ICD-11', 'MedDRA', 'SNOMED CT', 'Other vocabulary', 'Free text']))

  unless ExtendedMetadataType.where(title:'Design_conditions_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_conditions_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_conditions_label_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Name of primary health condition or disease considered in the Project.', label: 'Primary health condition or disease name(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_conditions_classification_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_conditions_classification_Project_cv, description:'Terminology/classification used for the health condition or disease.', label:'Terminology/classification(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_conditions_code_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Code of the health condition or disease in the terminology/classification used.', label: 'Code of the health condition or disease')
    emt.save!
  end


  # ************* Groups of diseases or conditions ****************
  Design_groupsOfDiseases_generally_Project_cv = SampleControlledVocab.where(title: 'Design_groupsOfDiseases_generally_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Certain infectious or parasitic diseases (I)', 'Neoplasms (II)', 'Diseases of the blood or blood-forming organs and certain disorders involving the immune mechanism (III)', 'Endocrine, nutritional and metabolic diseases (IV)', 'Mental and behavioural disorders (V)', 'Diseases of the nervous system (VI)', 'Diseases of the eye and adnexa (VII)', 'Diseases of the ear or mastoid process (VIII)', 'Diseases of the circulatory system (IX)', 'Diseases of the respiratory system (X)', 'Diseases of the digestive system (XI)', 'Diseases of the skin and subcutaneous tissue (XII)', 'Diseases of the musculoskeletal system and connective tissue (XIII)', 'Diseases of the genitourinary system (XIV)', 'Pregnancy, childbirth or the puerperium (XV)', 'Certain conditions originating in the perinatal period (XVI)', 'Congenital malformations, deformations and chromosomal abnormalities (XVII)', 'Symptoms, signs and abnormal clinical and laboratory findings, not elsewhere classified (XVIII)', 'Injury, poisoning and certain other consequences of external causes (XIX)', 'External causes of morbidity or mortality (XX)', 'Factors influencing health status and contact with health services (XXI)', 'Other', 'Not applicable', 'Unknown']))

  Design_groupsOfDiseases_conditions_Project_cv = SampleControlledVocab.where(title: 'Design_groupsOfDiseases_conditions_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Lower level ICD-10 (https://icd.who.int/browse10/2019/en), with autocomplete']))

  unless ExtendedMetadataType.where(title:'Design_groupsOfDiseases_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_groupsOfDiseases_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_groupsOfDiseases_generally_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_groupsOfDiseases_generally_Project_cv, description:'General groups of diseases or conditions on which the data were collected in the Project.', label:'Which groups of diseases or conditions were the data collected on?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_groupsOfDiseases_conditions_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_groupsOfDiseases_conditions_Project_cv, description:'Diseases or conditions on which the data were collected in the Project.', label:'On which diseases or conditions were the data collected?')
    emt.save!
  end


  # ************* Administrative information about the [RESOURCE] ****************
  Design_administrativeInformation_ethicsCommitteeApproval_Project_cv = SampleControlledVocab.where(title: 'Design_administrativeInformation_ethicsCommitteeApproval_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Request for approval not yet submitted', 'Request for approval submitted, approval pending', 'Request for approval submitted, approval granted', 'Request for approval submitted, exempt granted', 'Request for approval submitted, approval denied', 'Approval not required', 'Study withdrawn prior to decision on approval', 'Unknown status of request approval']))

  Design_administrativeInformation_status_Project_cv = SampleControlledVocab.where(title: 'Design_administrativeInformation_status_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['At the planning stage', 'Ongoing (I): Recruitment ongoing, but data collection not yet started', 'Ongoing (II): Recruitment and data collection ongoing', 'Ongoing (III): Recruitment completed, but data collection ongoing', 'Ongoing (IV): Recruitment and data collection completed, but data quality management ongoing', 'Suspended: Recruitment, data collection, or data quality management, halted, but potentially will resume', 'Terminated: Recruitment, data collection, data and quality management halted prematurely and will not resume', 'Completed: Recruitment, data collection, and data quality management completed normally', 'Other']))

  Design_administrativeInformation_statusEnrollingByInvitation_Project_cv = SampleControlledVocab.where(title: 'Design_administrativeInformation_statusEnrollingByInvitation_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes', 'No', 'Not applicable']))

  unless ExtendedMetadataType.where(title:'Design_administrativeInformation_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_administrativeInformation_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_administrativeInformation_ethicsCommitteeApproval_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_administrativeInformation_ethicsCommitteeApproval_Project_cv, description:'Status of the Project approval from the (leading) ethics committee.', label:'Status of the ethics committee approval')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_administrativeInformation_status_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_administrativeInformation_status_Project_cv, description:'Overall status of the Project.', label:'Overall Project status')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_administrativeInformation_statusEnrollingByInvitation_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_administrativeInformation_statusEnrollingByInvitation_Project_cv, description:'Specification whether Project participants are selected from a predetermined population.', label:'Participants enrolled by invitation?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_administrativeInformation_startDate_Project', sample_attribute_type: @date_type, sample_controlled_vocab: nil, description: 'Start date of data collection for the Project.', label: 'Start date')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_administrativeInformation_endDate_Project', sample_attribute_type: @date_type, sample_controlled_vocab: nil, description: 'In case of a Project with patients or other participants, it is the date when the last participant is examined or receives an intervention, or the date of the last participant�s last visit.', label: 'End date')
    emt.save!
  end


  # ************* Contributor(s) of the [RESOURCE] ****************
  Resource_contributors_nameType_Project_cv = SampleControlledVocab.where(title: 'Resource_contributors_nameType_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Personal', 'Organisational']))

  unless ExtendedMetadataType.where(title:'Resource_contributors_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_contributors_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_nameType_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_contributors_nameType_Project_cv, description:'Indication whether the contribution was made by person(s) or organisation(s)/institution(s)/group(s).', label:'Is it a personal or organisational contribution?(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_organisational_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_contributors_organisational_Project', supported_type:'ExtendedMetadata').first, label: 'Details about the contributing organisation(s)/institution(s)/group(s)' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_personal_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_contributors_personal_Project', supported_type:'ExtendedMetadata').first, label: 'Details about the contributing person(s)' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_email_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Email address of the  person, group of persons or institution/organisation.', label: 'Email address')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_phone_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Phone number of the  person, group of persons or institution/organisation.', label: 'Phone number')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_affiliations_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_contributors_affiliations_Project', supported_type:'ExtendedMetadata').first, label: 'Organisation(s) associated with the contributor' )
    emt.save!
  end


  # ************* Alternative identifiers ****************
  Resource_idsAlternative_scheme_Project_cv = SampleControlledVocab.where(title: 'Resource_idsAlternative_scheme_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['DRKS', 'NCT (ClinicalTrials.gov)', 'ISRCTN', 'EudraCT', 'EUDAMED', 'UTN', 'KonsortSWD', 'MDM Portal', 'Other']))

  unless ExtendedMetadataType.where(title:'Resource_idsAlternative_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_idsAlternative_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_idsAlternative_scheme_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_idsAlternative_scheme_Project_cv, description:'Type/name of the system where the given Project is already registered.', label:'Type of the registry(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_idsAlternative_identifier_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Identifier (ID) assigned to the given Project by another registering system, e.g. by a registry of clinical trials or a data repository.', label: 'Identifier(*)')
    emt.save!
  end


  # ************* Characteristics of the [RESOURCE] ****************
  Design_primaryDesign_Project_cv = SampleControlledVocab.where(title: 'Design_primaryDesign_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Non-interventional', 'Interventional']))

  Design_mortalityData_Project_cv = SampleControlledVocab.where(title: 'Design_mortalityData_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Yes, vital status only (cause of death missing)', 'Yes, with cause of death', 'No']))

  Design_centers_Project_cv = SampleControlledVocab.where(title: 'Design_centers_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Monocentric', 'Multicentric']))

  Design_dataProviders_Project_cv = SampleControlledVocab.where(title: 'Design_dataProviders_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['One data provider', 'Several data providers']))

  Design_subject_Project_cv = SampleControlledVocab.where(title: 'Design_subject_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Person', 'Animal', 'Other', 'Unknown']))

  Design_assessments_Project_cv = SampleControlledVocab.where(title: 'Design_assessments_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Diet/Nutrition', 'Physical activity', 'Tobacco use', 'Alcohol consumption', 'Body weight', 'Body height', 'Waist circumference', 'Body Mass Index', 'Body fat percentage', 'Sociodemographic information']))

  unless ExtendedMetadataType.where(title:'Design_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Design_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_primaryDesign_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_primaryDesign_Project_cv, description:'Non-interventional design refers to a Project that does not aim to alter its outcomes of interest. Interventional design refers to a Project that aims to alter its outcomes of interest.', label:'Is it an interventional or non-interventional Project?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_studyType_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_studyType_Project', supported_type:'ExtendedMetadata').first, label: 'Specification of the type of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_conditions_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_conditions_Project', supported_type:'ExtendedMetadata').first, label: 'Primary health condition(s) or disease(s) considered in the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_groupsOfDiseases_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_groupsOfDiseases_Project', supported_type:'ExtendedMetadata').first, label: 'Groups of diseases or conditions(*)' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_mortalityData_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_mortalityData_Project_cv, description:'Indication whether mortality data are collected in the Project.', label:'Collects mortality data?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_administrativeInformation_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_administrativeInformation_Project', supported_type:'ExtendedMetadata').first, label: 'Administrative information about the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_centers_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_centers_Project_cv, description:'Specification whether the Project is conducted at only one or at more than one Project center.', label:'Mono- or multicentric?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_centersNumber_Project', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Number of centers involved in the Project.', label: 'Number of centers')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataProviders_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_dataProviders_Project_cv, description:'Specification whether the Project involves only one or more than one data provider.', label:'One or more data providers?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataProvidersNumber_Project', sample_attribute_type: @int_type, sample_controlled_vocab: nil, description: 'Number of data providers involved in the Project.', label: 'Number of data providers')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_subject_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Design_subject_Project_cv, description:'The primary subject addressed by the Project, i.e. a person, an animal or other subject types.', label:'Primary subject(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_eligibilityCriteria_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_eligibilityCriteria_Project', supported_type:'ExtendedMetadata').first, label: 'Eligibility criteria for Project participants' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_population_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_population_Project', supported_type:'ExtendedMetadata').first, label: 'Population of the Project(*)' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventions_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_interventions_Project', supported_type:'ExtendedMetadata').first, label: 'Interventions of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_exposures_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_exposures_Project', supported_type:'ExtendedMetadata').first, label: 'Exposures of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_outcomes_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_outcomes_Project', supported_type:'ExtendedMetadata').first, label: 'Outcome measures in the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_comment_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Any additional information about specific aspects of the Project that could not be captured by other fields.', label: 'Additional information about the Project')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_assessments_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Design_assessments_Project_cv, description:'Any additional assessments/measurements included in the Project.', label:'Additional assessments/measurements in the Project')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_dataSharingPlan_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_dataSharingPlan_Project', supported_type:'ExtendedMetadata').first, label: 'Data sharing strategy of the Project(*)' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_nonInterventional_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_nonInterventional_Project', supported_type:'ExtendedMetadata').first, label: 'Non-interventional aspects of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_interventional_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_interventional_Project', supported_type:'ExtendedMetadata').first, label: 'Interventional aspects of the Project' )
    emt.save!
  end


  # ************* Resource classification ****************
  Resource_classification_type_Project_cv = SampleControlledVocab.where(title: 'Resource_classification_type_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(
                          ['Study', 'Substudy', 'Biobank', 'Case report form', 'Code book', 'Data dictionary', 'Data management plan', 'Dataset', 'Discussion guide', 'Informed consent form', 'Interview scheme and themes', 'Manual of operations (SOPs)', 'Observation guide', 'Participant tasks', 'Patient information sheet', 'Questionnaire', 'Registry', 'Secondary data source', 'Statistical analysis plan', 'Study protocol', 'Other data collection instrument', 'Other study document', 'Other']))

  unless ExtendedMetadataType.where(title:'Resource_classification_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_classification_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_classification_type_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_classification_type_Project_cv, description:'A term describing the resource.', label:'Type of the resource',required: true)
    emt.save!
  end


  # ************* Title(s)/name(s) of the [RESOURCE] ****************
  Resource_titles_language_Project_cv = SampleControlledVocab.where(title: 'Resource_titles_language_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(lang_array))

  unless ExtendedMetadataType.where(title:'Resource_titles_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_titles_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_titles_text_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Scientific unabbreviated title or name of the Project.  ', label: 'Title/name',required: true)
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_titles_language_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_titles_language_Project_cv, description:'Language in which the title/name is provided.', label:'Language of the title/name',required: true)
    emt.save!
  end


  # ************* Acronym(s) of the [RESOURCE] ****************
  Resource_acronyms_language_Project_cv = SampleControlledVocab.where(title: 'Resource_acronyms_language_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(lang_array))

  unless ExtendedMetadataType.where(title:'Resource_acronyms_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_acronyms_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_acronyms_text_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'If existing, acronym(s) of the Project.', label: 'Acronym',required: true)
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_acronyms_language_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_acronyms_language_Project_cv, description:'Language in which the acronym is provided.', label:'Language of the acronym',required: true)
    emt.save!
  end


  # ************* Description(s) of the [RESOURCE] ****************
  Resource_descriptions_language_Project_cv = SampleControlledVocab.where(title: 'Resource_descriptions_language_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(lang_array))

  unless ExtendedMetadataType.where(title:'Resource_descriptions_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_descriptions_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_descriptions_text_Project', sample_attribute_type: @text_type, sample_controlled_vocab: nil, description: 'Short plain text summary of the Project.', label: 'Description',required: true)
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_descriptions_language_Project', sample_attribute_type: @cv_type, sample_controlled_vocab:Resource_descriptions_language_Project_cv, description:'Language in which the description text is provided.', label:'Language of the description',required: true)
    emt.save!
  end


  # ************* Keyword(s) describing the  [RESOURCE] ****************
  unless ExtendedMetadataType.where(title:'Resource_keywords_Project', supported_type:'ExtendedMetadata').any?
    emt = ExtendedMetadataType.new(title: 'Resource_keywords_Project', supported_type:'ExtendedMetadata')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_keywords_label_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Keyword(s) describing the Project.', label: 'Keyword(*)')
    emt.save!
  end


  # ************* Resource ****************
  Resource_languages_Project_cv = SampleControlledVocab.where(title: 'Resource_languages_Project').first_or_create!(
                      sample_controlled_vocab_terms_attributes: create_sample_controlled_vocab_terms_attributes(lang_array))

  unless ExtendedMetadataType.where(title:'Nfdi4Health MDS 3.3', supported_type:'Project').any?
    emt = ExtendedMetadataType.new(title: 'Nfdi4Health MDS 3.3', supported_type:'Project')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_identifier_Project', sample_attribute_type: @string_type, sample_controlled_vocab: nil, description: 'Unique identifier of the resource used for identification within the NFDI4Health.', label: 'ID of the Project(*)')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_classification_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_classification_Project', supported_type:'ExtendedMetadata').first, label: 'Resource classification(*)' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_titles_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_titles_Project', supported_type:'ExtendedMetadata').first, label: 'Title(s)/name(s) of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_acronyms_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_acronyms_Project', supported_type:'ExtendedMetadata').first, label: 'Acronym(s) of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_descriptions_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_descriptions_Project', supported_type:'ExtendedMetadata').first, label: 'Description(s) of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_keywords_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_keywords_Project', supported_type:'ExtendedMetadata').first, label: 'Keyword(s) describing the  Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_languages_Project', sample_attribute_type: @cv_list_type, sample_controlled_vocab:Resource_languages_Project_cv, description:'Language(s) in which the   Project is conducted/provided.', label:'Language(s) of the Project')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_webpage_Project', sample_attribute_type: @link_type, sample_controlled_vocab: nil, description: 'If existing, a link to the web page directly relevant to the  Project.', label: 'Web page of the Project')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_contributors_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_contributors_Project', supported_type:'ExtendedMetadata').first, label: 'Contributor(s) of the Project' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_idsAlternative_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata (multiple)').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Resource_idsAlternative_Project', supported_type:'ExtendedMetadata').first, label: 'Alternative identifiers' )
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_nutritionalData_Project', sample_attribute_type: @bool_type, sample_controlled_vocab: nil, description: 'Indication whether the Project collects nutritional data.', label: 'Collects nutritional data?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Resource_chronicDiseases_Project', sample_attribute_type: @bool_type, sample_controlled_vocab: nil, description: 'Indication whether the Project addresses chronic diseases.', label: 'Includes chronic diseases?')
    emt.extended_metadata_attributes << ExtendedMetadataAttribute.new(title: 'Design_Project', sample_attribute_type: SampleAttributeType.where(title:'Linked Extended Metadata').first , linked_extended_metadata_type: ExtendedMetadataType.where(title:'Design_Project', supported_type:'ExtendedMetadata').first, label: 'Characteristics of the Project' )
    emt.save!
  end

puts '... Done!'
end
