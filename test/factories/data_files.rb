# DataFile
Factory.define(:data_file) do |f|
  f.with_project_contributor
  f.sequence(:title) { |n| "A Data File_#{n}" }

  f.after_create do |data_file|
    if data_file.content_blob.blank?
      data_file.content_blob = Factory.create(:pdf_content_blob, asset: data_file, asset_version: data_file.version)
    else
      data_file.content_blob.asset = data_file
      data_file.content_blob.asset_version = data_file.version
      data_file.content_blob.save
    end
  end
end

Factory.define(:public_data_file, parent: :data_file) do |f|
  f.policy { Factory(:downloadable_public_policy) }
end

Factory.define(:min_data_file, class: DataFile) do |f|
  f.with_project_contributor
  f.title 'A Minimal DataFile'
  f.projects { [Factory(:min_project)] }
  f.after_create do |data_file|
    data_file.content_blob = Factory.create(:pdf_content_blob, asset: data_file, asset_version: data_file.version)
  end
end

Factory.define(:max_data_file, class: DataFile) do |f|
  f.with_project_contributor
  f.title 'A Maximal DataFile'
  f.description 'Results - Sampling conformations of ATP-Mg inside the binding pocket'
  f.discussion_links { [Factory.build(:discussion_link, label:'Slack')] }
  f.assays { [Factory(:public_assay)] }
  f.events {[Factory.build(:event, policy: Factory(:public_policy))]}
  f.workflows {[Factory.build(:workflow, policy: Factory(:public_policy))]}
  f.relationships {[Factory(:relationship, predicate: Relationship::RELATED_TO_PUBLICATION, other_object: Factory(:publication))]}
  f.after_create do |data_file|
    if data_file.content_blob.blank?
      data_file.content_blob = Factory.create(:pdf_content_blob, asset: data_file, asset_version: data_file.version)
    end
    data_file.annotate_with(['DataFile-tag1', 'DataFile-tag2', 'DataFile-tag3', 'DataFile-tag4', 'DataFile-tag5'], 'tag', data_file.contributor)
    data_file.save!
  end
  f.other_creators 'Blogs, Joe'
  f.assets_creators { [AssetsCreator.new(affiliation: 'University of Somewhere', creator: Factory(:person, first_name: 'Some', last_name: 'One'))] }
end

Factory.define(:rightfield_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :rightfield_content_blob
end

Factory.define(:blank_rightfield_master_template_data_file, parent: :data_file) do |f|
  f.association :content_blob, factory: :blank_rightfield_master_template
end


Factory.define(:rightfield_annotated_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :rightfield_annotated_content_blob
end

Factory.define(:non_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :cronwright_model_content_blob
end

Factory.define(:xlsx_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsx_content_blob
end

Factory.define(:xlsm_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsm_content_blob
end

Factory.define(:csv_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :csv_content_blob
end

Factory.define(:xlsx_population_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsx_population_content_blob
end

Factory.define(:csv_population_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :csv_population_content_blob
end

Factory.define(:tsv_population_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :tsv_population_content_blob
end

Factory.define(:xlsx_population_no_header_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsx_population_no_header_content_blob
end

Factory.define(:xlsx_population_no_study_header_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsx_population_no_study_header_content_blob
end

Factory.define(:xlsx_population_no_investigation_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsx_population_no_investigation_content_blob
end

Factory.define(:xlsx_population_no_study_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsx_population_no_study_content_blob
end

Factory.define(:xlsx_population_just_isa_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :xlsx_population_just_isa
end

Factory.define(:small_test_spreadsheet_datafile, parent: :data_file) do |f|
  f.association :content_blob, factory: :small_test_spreadsheet_content_blob
end

Factory.define(:strain_sample_data_file, parent: :data_file) do |f|
  f.association :content_blob, factory: :strain_sample_data_content_blob
end

Factory.define(:jerm_data_file, class: DataFile) do |f|
  f.sequence(:title) { |n| "A Data File_#{n}" }
  f.contributor nil
  f.projects { [Factory(:project)] }
  f.association :content_blob, factory: :url_content_blob

  f.after_create do |data_file|
    if data_file.content_blob.blank?
      data_file.content_blob = Factory.create(:pdf_content_blob, asset: data_file, asset_version: data_file.version)
    else
      data_file.content_blob.asset = data_file
      data_file.content_blob.asset_version = data_file.version
      data_file.content_blob.save
    end
  end
end

Factory.define(:subscribable, parent: :data_file) {}

# DataFile::Version
Factory.define(:data_file_version, class: DataFile::Version) do |f|
  f.association :data_file
  f.projects { data_file.projects }
  f.after_create do |data_file_version|
    data_file_version.data_file.version += 1
    data_file_version.data_file.save
    data_file_version.version = data_file_version.data_file.version
    data_file_version.title = data_file_version.data_file.title
    data_file_version.save
  end
end

Factory.define(:data_file_version_with_blob, parent: :data_file_version) do |f|
  f.after_create do |data_file_version|
    if data_file_version.content_blob.blank?
      Factory.create(:pdf_content_blob,
                     asset: data_file_version.data_file,
                     asset_version: data_file_version.version)
    else
      data_file_version.content_blob.asset = data_file_version.data_file
      data_file_version.content_blob.asset_version = data_file_version.version
      data_file_version.content_blob.save
    end
  end
end

Factory.define(:api_pdf_data_file, parent: :data_file) do |f|
  f.association :content_blob, factory: :blank_pdf_content_blob
end

Factory.define(:api_txt_data_file, parent: :data_file) do |f|
  f.association :content_blob, factory: :blank_txt_content_blob
end
