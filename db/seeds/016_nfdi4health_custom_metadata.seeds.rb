# Initialisation of aliases for common sample attributes types, for easier use.
@mds_version = '3.0'

@int_type = SampleAttributeType.find_or_initialize_by(title: 'Integer')
@int_type.update(base_type: Seek::Samples::BaseType::INTEGER, placeholder: '1')

@bool_type = SampleAttributeType.find_or_initialize_by(title: 'Boolean')
@bool_type.update(base_type: Seek::Samples::BaseType::BOOLEAN)

@float_type = SampleAttributeType.find_or_initialize_by(title: 'Real number')
@float_type.update(base_type: Seek::Samples::BaseType::FLOAT, placeholder: '0.5')

@date_type = SampleAttributeType.find_or_initialize_by(title: 'Date')
@date_type.update(base_type: Seek::Samples::BaseType::DATE, placeholder: 'January 1, 2022')

@string_type = SampleAttributeType.find_or_initialize_by(title: 'String')
@string_type.update(base_type: Seek::Samples::BaseType::STRING)

@cv_type = SampleAttributeType.find_or_initialize_by(title: 'Controlled Vocabulary')
@cv_type.update(base_type: Seek::Samples::BaseType::CV)

@text_type = SampleAttributeType.find_or_initialize_by(title: 'Text')
@text_type.update(base_type: Seek::Samples::BaseType::TEXT, placeholder: '1')

@link_type = SampleAttributeType.find_or_initialize_by(title: 'Web link')
@link_type.update(base_type: Seek::Samples::BaseType::STRING, regexp: URI.regexp(%w(http https)).to_s, placeholder: 'http://www.example.com', resolution: '\\0')

@cv_list_type = SampleAttributeType.find_or_initialize_by(title:'Controlled Vocabulary List')
@cv_list_type.update(base_type: Seek::Samples::BaseType::CV_LIST)

# helper to create sample controlled vocab
def create_cv_attr_terms(array)
  attributes = []
  array.each do |type|
    attributes << { label: type }
  end
  attributes
end

def sanitize_label(s)
  s.downcase.gsub('(', '_').gsub(')', '_').gsub(' ', '_')
end

def create_cm_attr(namespace:, label:, required:, type:, cv: nil)
  CustomMetadataAttribute.where(title: "#{namespace}/#{sanitize_label(label)}").first_or_create!(
    label: label,
    required: required,
    sample_attribute_type: type,
    sample_controlled_vocab: cv
  )
end

##
#def create_cm_attr(namespace:, label:, required:, type:, cv: nil, pos:, descrp:)
#  CustomMetadataAttribute.where(title: "#{namespace}/#{sanitize_label(label)}").first_or_create!(
#    label: label,
#    description: descrp,
#    required: required,
#    sample_attribute_type: type,
#    sample_controlled_vocab: cv,
#    pos: pos
#  )
#end

disable_authorization_checks do
  @resource_classification_resource_type_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/resource-classification-resource-type').first_or_create!(
    title: 'RESOURCE CLASSIFICATION RESOURCE TYPE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      [
        '*Study', '*Substudy/Data collection event', 'Dataset', 'Study protocol', 'Protocol amendment', 'Data dictionary', 'Informed consent form', 'Patient information sheet', 'Manual of operations (SOPs)', 'Statistical analysis plan', 'Data management plan', 'Case report form', 'Code book', 'Questionnaire', 'Interview scheme and themes', 'Observation guide', 'Discussion guide', 'Participant tasks', 'Other data collection instrument', 'Other study document', 'Other'
      ])
  )
end

disable_authorization_checks do
  @resource_classification_resource_type_general_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/resource-classification-resource-type-general').first_or_create!(
    title: 'RESOURCE CLASSIFICATION RESOURCE TYPE GENERAL',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Audiovisual', 'Book', 'Book chapter', 'Collection', 'Computational notebook', 'Conference paper', 'Conference proceeding', 'Data paper', 'Dataset', 'Dissertation', 'Event', 'Image', 'Interactive resource', 'Journal', 'Journal article', 'Model', 'Output management plan', 'Peer review', 'Physical object', 'Preprint', 'Report', 'Service', 'Software', 'Sound', 'Standard', 'Text', 'Workflow', 'Other'])
  )
end

disable_authorization_checks do
  @language_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/language').first_or_create!(
    title: 'LANGUAGE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['EN (English)', 'DE (German)', 'ES (Spanish)', 'FR (French)', 'Other'])
  )
end

disable_authorization_checks do
  @resource_acronyms_language_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/resource-acronyms-language').first_or_create!(
    title: 'RESOURCE ACRONYMS LANGUAGE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['EN (English)', 'DE (German)', 'ES (Spanish)', 'FR (French)', 'Other'])
  )
end

disable_authorization_checks do
  @resource_description_english_language_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/resource-description-english-language').first_or_create!(
    title: 'RESOURCE DESCRIPTION ENGLISH LANGUAGE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['EN (English)'])
  )
end

disable_authorization_checks do
  @Resource_resource_languages_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/Resource-resource-languages').first_or_create!(
    title: 'RESOURCE RESOURCE LANGUAGES',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Language names from the ISO 639-1 list'])
  )
end

disable_authorization_checks do
  @ids_alternative_type_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/ids-alternative-type').first_or_create!(
    title: 'IDS ALTERNATIVE TYPE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['DRKS', 'NCT (ClinicalTrials.gov)', 'ISRCTN', 'EudraCT', 'EUDAMED', 'UTN', 'KonsortSWD', 'MDM Portal', 'Other'])
  )
end

disable_authorization_checks do
  @study_type_study_type_interventional_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-type-study-type-interventional').first_or_create!(
    title: 'STUDY TYPE STUDY TYPE INTERVENTIONAL',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Single group ', 'Parallel ', 'Crossover ', 'Factorial ', 'Sequential ', 'Other', 'Unknown'])
  )
end

disable_authorization_checks do
  @study_type_study_type_non_interventional_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-type-study-type-non-interventional').first_or_create!(
    title: 'STUDY TYPE STUDY TYPE NON INTERVENTIONAL',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Case-control', 'Nested case-control', 'Case-only', 'Case-crossover', 'Ecologic or community studies', 'Family-based', 'Twin study', 'Cohort', 'Case-cohort', 'Birth cohort', 'Trend', 'Panel', 'Longitudinal', 'Cross-section', 'Cross-section ad-hoc follow-up', 'Time series', 'Quality control', 'Registry', 'Other', 'Unknown'])
  )
end

disable_authorization_checks do
  @study_conditions_study_conditions_classification_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-conditions-study-conditions-classification').first_or_create!(
    title: 'STUDY CONDITIONS STUDY CONDITIONS CLASSIFICATION',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['MeSH', 'ICD-10', 'MedDRA', 'SNOMED CT', 'Other vocabulary', 'Free text'])
  )
end

disable_authorization_checks do
  @study_groups_of_diseases_study_groups_of_diseases_generally_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-groups-of-diseases-study-groups-of-diseases-generally').first_or_create!(
    title: 'STUDY GROUPS OF DISEASES STUDY GROUPS OF DISEASES GENERALLY',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Certain infectious or parasitic diseases (01)', 'Neoplasms (02)', 'Diseases of the blood or blood-forming organs (03)', 'Diseases of the immune system (04)', 'Endocrine, nutritional or metabolic diseases (05)', 'Mental, behavioural or neurodevelopmental disorders (06)', 'Sleep-wake disorders (07)', 'Diseases of the nervous system (08)', 'Diseases of the visual system (09)', 'Diseases of the ear or mastoid process (10)', 'Diseases of the circulatory system (11)', 'Diseases of the respiratory system (12)', 'Diseases of the digestive system (13)', 'Diseases of the skin (14)', 'Diseases of the musculoskeletal system or connective tissue (15)', 'Diseases of the genitourinary system (16)', 'Conditions related to sexual health (17)', 'Pregnancy, childbirth or the puerperium (18)', 'Certain conditions originating in the perinatal period (19)', 'Developmental anomalies (20)', 'Symptoms, signs or clinical findings, not elsewhere classified (21)', 'Injury, poisoning or certain other consequences of external causes (22)', 'External causes of morbidity or mortality (23)', 'Factors influencing health status or contact with health services (24)', 'Other', 'Not applicable', 'Unknown'])
  )
end

disable_authorization_checks do
  @study_design_mortality_data_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-mortality-data').first_or_create!(
    title: 'STUDY DESIGN MORTALITY DATA',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Yes, vital status only (cause of death missing) ', 'Yes, with cause of death ', 'No'])
  )
end

disable_authorization_checks do
  @study_design_study_ethics_committee_approval_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-study-ethics-committee-approval').first_or_create!(
    title: 'STUDY DESIGN STUDY ETHICS COMMITTEE APPROVAL',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Request for approval not yet submitted', 'Request for approval submitted, approval pending', 'Request for approval submitted, approval granted', 'Request for approval submitted, exempt granted', 'Request for approval submitted, approval denied', 'Approval not required', 'Study withdrawn prior to decision on approval', 'Unknown status of request approval'])
  )
end

disable_authorization_checks do
  @study_design_study_status_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-study-status').first_or_create!(
    title: 'STUDY DESIGN STUDY STATUS',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['At the planning stage', 'Ongoing (I): Recruitment ongoing, but data collection not yet started', 'Ongoing (II): Recruitment and data collection ongoing', 'Ongoing (III): Recruitment completed, but data collection ongoing', 'Ongoing (IV): Recruitment and data collection completed, but data quality management ongoing', 'Suspended: Recruitment, data collection, or data quality management, halted, but potentially will resume', 'Terminated: Recruitment, data collection, data and quality management halted prematurely and will not resume', 'Completed: Recruitment, data collection, and data quality management completed normally', 'Other'])
  )
end

disable_authorization_checks do
  @study_design_study_status_enrolling_by_invitation_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-study-status-enrolling-by-invitation').first_or_create!(
    title: 'STUDY DESIGN STUDY STATUS ENROLLING BY INVITATION',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Yes', 'No', 'Not applicable'])
  )
end

disable_authorization_checks do
  @study_design_study_centers_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-study-centers').first_or_create!(
    title: 'STUDY DESIGN STUDY CENTERS',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Monocentric', 'Multicentric'])
  )
end

disable_authorization_checks do
  @study_design_study_subject_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-study-subject').first_or_create!(
    title: 'STUDY DESIGN STUDY SUBJECT',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Person', 'Animal', 'Other', 'Unknown'])
  )
end

disable_authorization_checks do
  @study_eligibility_age_time_unit_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-eligibility-age-min-time-unit').first_or_create!(
    title: 'STUDY ELIGIBILITY AGE MIN TIME UNIT',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Years', 'Months', 'Weeks', 'Days', 'Hours', 'Minutes', 'Weeks of gestation'])
  )
end

disable_authorization_checks do
  @study_eligibility_criteria_study_eligibility_genders_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-eligibility-criteria-study-eligibility-genders').first_or_create!(
    title: 'STUDY ELIGIBILITY CRITERIA STUDY ELIGIBILITY GENDERS',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Male', 'Female', 'Diverse', 'Not applicable'])
  )
end

disable_authorization_checks do
  @study_interventions_study_intervention_type_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-interventions-study-intervention-type').first_or_create!(
    title: 'STUDY INTERVENTIONS STUDY INTERVENTION TYPE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Drug (including placebo)', 'Device (including sham)', 'Biological/Vaccine', 'Procedure/Surgery', 'Radiation', 'Behavioral (e.g., psychotherapy, lifestyle counseling)', 'Genetic (including gene transfer, stem cell and recombinant DNA)', 'Dietary supplement (e.g., vitamins, minerals)', 'Combination product (combining a drug and device, a biological product and device; a drug and biological product; or a drug, biological product, and device)', 'Diagnostic test (e.g., imaging, in-vitro)', 'Other'])
  )
end

disable_authorization_checks do
  @study_outcomes_study_outcome_type_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-outcomes-study-outcome-type').first_or_create!(
    title: 'STUDY OUTCOMES STUDY OUTCOME TYPE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Primary', 'Secondary', 'Other '])
  )
end

disable_authorization_checks do
  @study_data_sharing_plan_study_data_sharing_plan_generally_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-data-sharing-plan-study-data-sharing-plan-generally').first_or_create!(
    title: 'STUDY DATA SHARING PLAN STUDY DATA SHARING PLAN GENERALLY',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Yes, there is a plan to make data available', 'No, there is no plan to make data available', 'Undecided, it is not yet known if data will be made available'])
  )
end

disable_authorization_checks do
  @study_data_sharing_plan_study_data_sharing_plan_supporting_information_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-data-sharing-plan-study-data-sharing-plan-supporting-information').first_or_create!(
    title: 'STUDY DATA SHARING PLAN STUDY DATA SHARING PLAN SUPPORTING INFORMATION',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Data dictionary', 'Study protocol', 'Protocol amendment', 'Statistical analysis plan', 'Analytic code', 'Informed consent form', 'Clinical study report', 'Manual of operations (SOP)', 'Case report form (template)', 'Questionnaire (template)', 'Code book', 'Other'])
  )
end

disable_authorization_checks do
  @study_data_sharing_plan_study_data_sharing_plan_datashield_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-data-sharing-plan-study-data-sharing-plan-datashield').first_or_create!(
    title: 'STUDY DATA SHARING PLAN STUDY DATA SHARING PLAN DATASHIELD',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Yes', 'No', 'Pending'])
  )
end

disable_authorization_checks do
  @study_design_interventional_study_phase_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-interventional-study-phase').first_or_create!(
    title: 'STUDY DESIGN INTERVENTIONAL STUDY PHASE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Early-phase-1', 'Phase-1', 'Phase-1-phase-2', 'Phase-2', 'Phase-2a', 'Phase-2b', 'Phase-2-phase-3', 'Phase-3', 'Phase-3a', 'Phase-3b', 'Phase-4', 'Other', 'Not applicable'])
  )
end

disable_authorization_checks do
  @study_masking_study_masking_roles_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-masking-study-masking-roles').first_or_create!(
    title: 'STUDY MASKING STUDY MASKING ROLES',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Participant', 'Care provider', 'Investigator', 'Outcomes assessor'])
  )
end

disable_authorization_checks do
  @study_design_interventional_study_allocation_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-interventional-study-allocation').first_or_create!(
    title: 'STUDY DESIGN INTERVENTIONAL STUDY ALLOCATION',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Randomized', 'Nonrandomized', 'Not applicable (for single-arm trials)'])
  )
end

disable_authorization_checks do
  @study_design_interventional_study_off_label_use_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-interventional-study-off-label-use').first_or_create!(
    title: 'STUDY DESIGN INTERVENTIONAL STUDY OFF LABEL USE',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      ['Yes', 'No', 'Not applicable'])
  )
end

disable_authorization_checks do
  @study_design_non_interventional_study_time_perspectives_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-non-interventional-study-time-perspectives').first_or_create!(
    title: 'STUDY DESIGN NON INTERVENTIONAL STUDY TIME PERSPECTIVES',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      [
        'Retrospective', 'Prospective', 'Cross-sectional', 'Other'
      ])
  )
end

disable_authorization_checks do
  @study_design_non_interventional_study_biospecimen_retention_cv = SampleControlledVocab.where(key: 'mds-#{@mds_version}/study-design-non-interventional-study-biospecimen-retention').first_or_create!(
    title: 'STUDY DESIGN NON INTERVENTIONAL STUDY BIOSPECIMEN RETENTION',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(
      [
        'None retained', 'Samples with DNA', 'Samples without DNA'
      ])
  )
end

country_code_array = {
  "AF"=>"Afghanistan",
  "AX"=>"Aland Islands",
  "AL"=>"Albania",
  "DZ"=>"Algeria",
  "AS"=>"American Samoa",
  "AD"=>"Andorra",
  "AO"=>"Angola",
  "AI"=>"Anguilla",
  "AQ"=>"Antarctica",
  "AG"=>"Antigua And Barbuda",
  "AR"=>"Argentina",
  "AM"=>"Armenia",
  "AW"=>"Aruba",
  "AU"=>"Australia",
  "AT"=>"Austria",
  "AZ"=>"Azerbaijan",
  "BS"=>"Bahamas",
  "BH"=>"Bahrain",
  "BD"=>"Bangladesh",
  "BB"=>"Barbados",
  "BY"=>"Belarus",
  "BE"=>"Belgium",
  "BZ"=>"Belize",
  "BJ"=>"Benin",
  "BM"=>"Bermuda",
  "BT"=>"Bhutan",
  "BO"=>"Bolivia",
  "BA"=>"Bosnia And Herzegovina",
  "BW"=>"Botswana",
  "BV"=>"Bouvet Island",
  "BR"=>"Brazil",
  "IO"=>"British Indian Ocean Territory",
  "BN"=>"Brunei Darussalam",
  "BG"=>"Bulgaria",
  "BF"=>"Burkina Faso",
  "BI"=>"Burundi",
  "KH"=>"Cambodia",
  "CM"=>"Cameroon",
  "CA"=>"Canada",
  "CV"=>"Cape Verde",
  "KY"=>"Cayman Islands",
  "CF"=>"Central African Republic",
  "TD"=>"Chad",
  "CL"=>"Chile",
  "CN"=>"China",
  "CX"=>"Christmas Island",
  "CC"=>"Cocos (Keeling) Islands",
  "CO"=>"Colombia",
  "KM"=>"Comoros",
  "CG"=>"Congo",
  "CD"=>"Congo, Democratic Republic",
  "CK"=>"Cook Islands",
  "CR"=>"Costa Rica",
  "CI"=>"Cote D'Ivoire",
  "HR"=>"Croatia",
  "CU"=>"Cuba",
  "CY"=>"Cyprus",
  "CZ"=>"Czech Republic",
  "DK"=>"Denmark",
  "DJ"=>"Djibouti",
  "DM"=>"Dominica",
  "DO"=>"Dominican Republic",
  "EC"=>"Ecuador",
  "EG"=>"Egypt",
  "SV"=>"El Salvador",
  "GQ"=>"Equatorial Guinea",
  "ER"=>"Eritrea",
  "EE"=>"Estonia",
  "ET"=>"Ethiopia",
  "FK"=>"Falkland Islands (Malvinas)",
  "FO"=>"Faroe Islands",
  "FJ"=>"Fiji",
  "FI"=>"Finland",
  "FR"=>"France",
  "GF"=>"French Guiana",
  "PF"=>"French Polynesia",
  "TF"=>"French Southern Territories",
  "GA"=>"Gabon",
  "GM"=>"Gambia",
  "GE"=>"Georgia",
  "DE"=>"Germany",
  "GH"=>"Ghana",
  "GI"=>"Gibraltar",
  "GR"=>"Greece",
  "GL"=>"Greenland",
  "GD"=>"Grenada",
  "GP"=>"Guadeloupe",
  "GU"=>"Guam",
  "GT"=>"Guatemala",
  "GG"=>"Guernsey",
  "GN"=>"Guinea",
  "GW"=>"Guinea-Bissau",
  "GY"=>"Guyana",
  "HT"=>"Haiti",
  "HM"=>"Heard Island & Mcdonald Islands",
  "VA"=>"Holy See (Vatican City State)",
  "HN"=>"Honduras",
  "HK"=>"Hong Kong",
  "HU"=>"Hungary",
  "IS"=>"Iceland",
  "IN"=>"India",
  "ID"=>"Indonesia",
  "IR"=>"Iran, Islamic Republic Of",
  "IQ"=>"Iraq",
  "IE"=>"Ireland",
  "IM"=>"Isle Of Man",
  "IL"=>"Israel",
  "IT"=>"Italy",
  "JM"=>"Jamaica",
  "JP"=>"Japan",
  "JE"=>"Jersey",
  "JO"=>"Jordan",
  "KZ"=>"Kazakhstan",
  "KE"=>"Kenya",
  "KI"=>"Kiribati",
  "KR"=>"Korea",
  "KW"=>"Kuwait",
  "KG"=>"Kyrgyzstan",
  "LA"=>"Lao People's Democratic Republic",
  "LV"=>"Latvia",
  "LB"=>"Lebanon",
  "LS"=>"Lesotho",
  "LR"=>"Liberia",
  "LY"=>"Libyan Arab Jamahiriya",
  "LI"=>"Liechtenstein",
  "LT"=>"Lithuania",
  "LU"=>"Luxembourg",
  "MO"=>"Macao",
  "MK"=>"Macedonia",
  "MG"=>"Madagascar",
  "MW"=>"Malawi",
  "MY"=>"Malaysia",
  "MV"=>"Maldives",
  "ML"=>"Mali",
  "MT"=>"Malta",
  "MH"=>"Marshall Islands",
  "MQ"=>"Martinique",
  "MR"=>"Mauritania",
  "MU"=>"Mauritius",
  "YT"=>"Mayotte",
  "MX"=>"Mexico",
  "FM"=>"Micronesia, Federated States Of",
  "MD"=>"Moldova",
  "MC"=>"Monaco",
  "MN"=>"Mongolia",
  "ME"=>"Montenegro",
  "MS"=>"Montserrat",
  "MA"=>"Morocco",
  "MZ"=>"Mozambique",
  "MM"=>"Myanmar",
  "NA"=>"Namibia",
  "NR"=>"Nauru",
  "NP"=>"Nepal",
  "NL"=>"Netherlands",
  "AN"=>"Netherlands Antilles",
  "NC"=>"New Caledonia",
  "NZ"=>"New Zealand",
  "NI"=>"Nicaragua",
  "NE"=>"Niger",
  "NG"=>"Nigeria",
  "NU"=>"Niue",
  "NF"=>"Norfolk Island",
  "MP"=>"Northern Mariana Islands",
  "NO"=>"Norway",
  "OM"=>"Oman",
  "PK"=>"Pakistan",
  "PW"=>"Palau",
  "PS"=>"Palestinian Territory, Occupied",
  "PA"=>"Panama",
  "PG"=>"Papua New Guinea",
  "PY"=>"Paraguay",
  "PE"=>"Peru",
  "PH"=>"Philippines",
  "PN"=>"Pitcairn",
  "PL"=>"Poland",
  "PT"=>"Portugal",
  "PR"=>"Puerto Rico",
  "QA"=>"Qatar",
  "RE"=>"Reunion",
  "RO"=>"Romania",
  "RU"=>"Russian Federation",
  "RW"=>"Rwanda",
  "BL"=>"Saint Barthelemy",
  "SH"=>"Saint Helena",
  "KN"=>"Saint Kitts And Nevis",
  "LC"=>"Saint Lucia",
  "MF"=>"Saint Martin",
  "PM"=>"Saint Pierre And Miquelon",
  "VC"=>"Saint Vincent And Grenadines",
  "WS"=>"Samoa",
  "SM"=>"San Marino",
  "ST"=>"Sao Tome And Principe",
  "SA"=>"Saudi Arabia",
  "SN"=>"Senegal",
  "RS"=>"Serbia",
  "SC"=>"Seychelles",
  "SL"=>"Sierra Leone",
  "SG"=>"Singapore",
  "SK"=>"Slovakia",
  "SI"=>"Slovenia",
  "SB"=>"Solomon Islands",
  "SO"=>"Somalia",
  "ZA"=>"South Africa",
  "GS"=>"South Georgia And Sandwich Isl.",
  "ES"=>"Spain",
  "LK"=>"Sri Lanka",
  "SD"=>"Sudan",
  "SR"=>"Suriname",
  "SJ"=>"Svalbard And Jan Mayen",
  "SZ"=>"Swaziland",
  "SE"=>"Sweden",
  "CH"=>"Switzerland",
  "SY"=>"Syrian Arab Republic",
  "TW"=>"Taiwan",
  "TJ"=>"Tajikistan",
  "TZ"=>"Tanzania",
  "TH"=>"Thailand",
  "TL"=>"Timor-Leste",
  "TG"=>"Togo",
  "TK"=>"Tokelau",
  "TO"=>"Tonga",
  "TT"=>"Trinidad And Tobago",
  "TN"=>"Tunisia",
  "TR"=>"Turkey",
  "TM"=>"Turkmenistan",
  "TC"=>"Turks And Caicos Islands",
  "TV"=>"Tuvalu",
  "UG"=>"Uganda",
  "UA"=>"Ukraine",
  "AE"=>"United Arab Emirates",
  "GB"=>"United Kingdom",
  "US"=>"United States",
  "UM"=>"United States Outlying Islands",
  "UY"=>"Uruguay",
  "UZ"=>"Uzbekistan",
  "VU"=>"Vanuatu",
  "VE"=>"Venezuela",
  "VN"=>"Viet Nam",
  "VG"=>"Virgin Islands, British",
  "VI"=>"Virgin Islands, U.S.",
  "WF"=>"Wallis And Futuna",
  "EH"=>"Western Sahara",
  "YE"=>"Yemen",
  "ZM"=>"Zambia",
  "ZW"=>"Zimbabwe"
}.values

disable_authorization_checks do
  @study_country_cv = SampleControlledVocab.where(key: "mds-#{@mds_version}/study-country").first_or_create!(
    title: 'Study Country',
    sample_controlled_vocab_terms_attributes: create_cv_attr_terms(country_code_array)
  )
end

def create_generic_attributes(namespace)
  [
    create_cm_attr(namespace:namespace, label: 'Resource Resource Identifier', required: true, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Resource Classification Resource Type', required: true, type: @cv_type, cv:@resource_classification_resource_type_cv),
    create_cm_attr(namespace:namespace, label: 'Resource Classification Resource Type General', required: false, type: @cv_type, cv:@resource_classification_resource_type_general_cv),
    create_cm_attr(namespace:namespace, label: 'Resource Titles Text', required: true, type: @text_type),
    create_cm_attr(namespace:namespace, label: 'Resource Titles Language', required: true, type: @cv_type, cv:@language_cv),
    create_cm_attr(namespace:namespace, label: 'Resource Acronyms Text', required: true, type: @text_type),
    create_cm_attr(namespace:namespace, label: 'Resource Acronyms Language', required: true, type: @cv_type, cv:@language_cv),
    create_cm_attr(namespace:namespace, label: 'Resource Description English Text', required: true, type: @text_type),
    create_cm_attr(namespace:namespace, label: 'Resource Description English Language', required: true, type: @cv_type, cv:@language_cv),
    create_cm_attr(namespace:namespace, label: 'Resource Keywords Resource Keywords Label', required: true, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Resource Resource Languages', required: false, type: @cv_type, cv:@language_cv),
    create_cm_attr(namespace:namespace, label: 'Resource Resource Web Page', required: false, type: @link_type),
    create_cm_attr(namespace:namespace, label: 'Ids Alternative Type', required: true, type: @cv_type, cv:@ids_alternative_type_cv),
    create_cm_attr(namespace:namespace, label: 'Ids Alternative Identifier', required: true, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Resource Nutritional Data', required: false, type: @bool_type),
    create_cm_attr(namespace:namespace, label: 'Resource Chronic Diseases', required: false, type: @bool_type),
    create_cm_attr(namespace:namespace, label: 'Study Conditions Study Conditions Label', required: true, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Conditions Study Conditions Classification', required: true, type: @cv_type, cv:@study_conditions_study_conditions_classification_cv),
    create_cm_attr(namespace:namespace, label: 'Study Conditions Study Conditions Classification Code', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Groups Of Diseases Study Groups Of Diseases Generally', required: false, type: @cv_type, cv:@study_groups_of_diseases_study_groups_of_diseases_generally_cv),
    create_cm_attr(namespace:namespace, label: 'Study Groups Of Diseases Study Diseases Conditions', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Design Mortality Data', required: false, type: @cv_type, cv:@study_design_mortality_data_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Study Ethics Committee Approval', required: false, type: @cv_type, cv:@study_design_study_ethics_committee_approval_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Study Status', required: true, type: @cv_type, cv:@study_design_study_status_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Study Status Enrolling By Invitation', required: false, type: @cv_type, cv:@study_design_study_status_enrolling_by_invitation_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Study Start Date', required: false, type: @date_type),
    create_cm_attr(namespace:namespace, label: 'Study Design Study End Date', required: false, type: @date_type),
    create_cm_attr(namespace:namespace, label: 'Study Design Study Countries', required: false, type: @cv_list_type, cv:@study_country_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Study Centers', required: false, type: @cv_type, cv:@study_design_study_centers_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Study Centers Number', required: false, type: @int_type),
    create_cm_attr(namespace:namespace, label: 'Study Design Study Subject', required: true, type: @cv_type, cv:@study_design_study_subject_cv),
    create_cm_attr(namespace:namespace, label: 'Study Eligibility Age Min Number', required: true, type: @int_type),
    create_cm_attr(namespace:namespace, label: 'Study Eligibility Age Min Time Unit', required: true, type: @cv_type, cv:@study_eligibility_age_time_unit_cv),
    create_cm_attr(namespace:namespace, label: 'Study Eligibility Age Max Number', required: true, type: @int_type),
    create_cm_attr(namespace:namespace, label: 'Study Eligibility Age Max Time Unit', required: true, type: @cv_type, cv:@study_eligibility_age_time_unit_cv),
    create_cm_attr(namespace:namespace, label: 'Study Eligibility Criteria Study Eligibility Genders', required: false, type: @cv_type, cv:@study_eligibility_criteria_study_eligibility_genders_cv),
    create_cm_attr(namespace:namespace, label: 'Study Eligibility Criteria Study Eligibility Inclusion Criteria', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Eligibility Criteria Study Eligibility Exclusion Criteria', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Interventions Study Intervention Name', required: true, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Interventions Study Intervention Type', required: false, type: @cv_type, cv:@study_interventions_study_intervention_type_cv),
    create_cm_attr(namespace:namespace, label: 'Study Interventions Study Intervention Description', required: false, type: @text_type),
    create_cm_attr(namespace:namespace, label: 'Study Interventions Study Intervention Arms Groups Label', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Outcomes Study Outcome Type', required: false, type: @cv_type, cv:@study_outcomes_study_outcome_type_cv),
    create_cm_attr(namespace:namespace, label: 'Study Outcomes Study Outcome Title', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Outcomes Study Outcome Description', required: false, type: @text_type),
    create_cm_attr(namespace:namespace, label: 'Study Outcomes Study Outcome Time Frame', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Data Sharing Plan Study Data Sharing Plan Generally', required: true, type: @cv_type, cv:@study_data_sharing_plan_study_data_sharing_plan_generally_cv),
    create_cm_attr(namespace:namespace, label: 'Study Data Sharing Plan Study Data Sharing Plan Supporting Information', required: false, type: @cv_type, cv:@study_data_sharing_plan_study_data_sharing_plan_supporting_information_cv),
    create_cm_attr(namespace:namespace, label: 'Study Data Sharing Plan Study Data Sharing Plan Time Frame', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Data Sharing Plan Study Data Sharing Plan Access Criteria', required: false, type: @string_type),
    create_cm_attr(namespace:namespace, label: 'Study Data Sharing Plan Study Data Sharing Plan Description', required: false, type: @text_type),
    create_cm_attr(namespace:namespace, label: 'Study Data Sharing Plan Study Data Sharing Plan Datashield', required: false, type: @cv_type, cv:@study_data_sharing_plan_study_data_sharing_plan_datashield_cv),
    create_cm_attr(namespace:namespace, label: 'Study Data Sharing Plan Study Data Sharing Plan Url', required: false, type: @link_type),

  ]
end

def create_interventional_attributes(namespace)
  [
    create_cm_attr(namespace:namespace, label: 'Study Type Study Type Interventional', required: false, type: @cv_type, cv:@study_type_study_type_interventional_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Interventional Study Phase', required: false, type: @cv_type, cv:@study_design_interventional_study_phase_cv),
    create_cm_attr(namespace:namespace, label: 'Study Masking Study Masking General', required: false, type: @bool_type),
    create_cm_attr(namespace:namespace, label: 'Study Masking Study Masking Roles', required: false, type: @cv_type, cv:@study_masking_study_masking_roles_cv),
    create_cm_attr(namespace:namespace, label: 'Study Masking Study Masking Description', required: false, type: @text_type),
    create_cm_attr(namespace:namespace, label: 'Study Design Interventional Study Allocation', required: false, type: @cv_type, cv:@study_design_interventional_study_allocation_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Interventional Study Off Label Use', required: false, type: @cv_type, cv:@study_design_interventional_study_off_label_use_cv)
  ]

end

def create_non_interventional_attributes(namespace)
  [
    create_cm_attr(namespace:namespace, label: 'Study Type Study Type Non Interventional', required: false, type: @cv_type, cv:@study_type_study_type_non_interventional_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Non Interventional Study Time Perspectives', required: false, type: @cv_type, cv:@study_design_non_interventional_study_time_perspectives_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Non Interventional Study Target Followup Duration', required: false, type: @float_type),
    create_cm_attr(namespace:namespace, label: 'Study Design Non Interventional Study Biospecimen Retention', required: false, type: @cv_type, cv:@study_design_non_interventional_study_biospecimen_retention_cv),
    create_cm_attr(namespace:namespace, label: 'Study Design Non Interventional Study Biospecimen Description', required: false, type: @text_type),
  ]

end

disable_authorization_checks do
  ['Study', 'Investigation'].each do |isa_type|
    CustomMetadataType.where(title: "MDS #{@mds_version} Interventional Study", supported_type: isa_type).first_or_create!(
      custom_metadata_attributes: create_generic_attributes("#{isa_type.downcase}.is") + create_interventional_attributes("#{isa_type.downcase}.is")
    )
    CustomMetadataType.where(title: "MDS #{@mds_version} Non-Interventional Study", supported_type: isa_type).first_or_create!(
      custom_metadata_attributes: create_generic_attributes("#{isa_type.downcase}.nis") + create_non_interventional_attributes("#{isa_type.downcase}.nis")
    )
  end
end

puts "Seeded MDS #{@mds_version}"
