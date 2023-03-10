#DO NOT EDIT THIS FILE.
#TO MODIFY THE DEFAULT SETTINGS, COPY seek_local.rb.pre to seek_local.rb AND EDIT THAT FILE INSTEAD

require 'object_extensions'
require 'array_extensions'
require 'seek/acts_as_cached_tree'
require 'seek/research_objects/acts_as_snapshottable'
require "attachment_fu_extensions"
require 'seek/taggable'
require 'bio'
require 'bio_extensions'
require 'uuid'
require 'sunspot_rails'
require 'string_extensions'
require 'recaptcha'
require 'acts_as_list'
require 'will_paginate'
require 'responds_to_parent'
require 'pothoven-attachment_fu'
require 'rightfield/rightfield'
require 'seek/rdf/rdf_generation'
require 'seek/search/background_reindexing'
require 'seek/subscribable'
require 'seek/permissions/publishing_permissions'
require 'seek/search/common_fields'
require 'mimemagic'
require 'private_address_check_monkeypatch'
require 'libreconv'
require 'omniauth-ldap'

SEEK::Application.configure do
  ASSET_ORDER = ['Person', 'Programme', 'Project', 'Institution', 'Investigation', 'Study', 'Assay', 'Strain', 'DataFile', 'Model', 'Sop', 'Publication', 'Presentation','SavedSearch', 'Organism', 'HumanDisease', 'Event']

  begin
    Seek::Config.propagate_all
  rescue Settings::DecryptionError
    puts "\n" * 3
    puts "#" * 40
    puts
    puts "WARNING - Could not decrypt settings!"
    puts
    puts "Please check the encryption key (filestore/attr_encrypted/key) is"
    puts "is present and is the same key used to encrypt the settings originally."
    puts
    puts "If you no longer have access to the original key you can clear any encrypted"
    puts "settings by running: rake seek:clear_encrypted_settings"
    puts
    puts "#" * 40
    puts "\n" * 3
  end

  Annotations::Config.attribute_names_to_allow_duplicates.concat(["tag"])
  Annotations::Config.versioning_enabled = false

  ENV['LANG'] = 'en_US.UTF-8'

  begin
    if ActiveRecord::Base.connection.data_source_exists?'delayed_jobs'
      # OpenbisFakeJob.create_initial_jobs
      # OpenbisGarbageJob.create_initial_jobs
    end
  rescue Exception=>e
    Rails.logger.error "Error creating default delayed jobs - #{e.message}"
  end


end
