require 'rest-client'

module Nfdi4Health

  class Client
    attr_accessor :transformed
    def initialize()
      @password = Seek::Config.n4h_password
      @url = Seek::Config.n4h_url.blank? ? nil : Seek::Config.n4h_url
      @authorization_url = Seek::Config.n4h_authorization_url.blank? ? nil : Seek::Config.n4h_authorization_url
      @username = Seek::Config.n4h_username.blank? ? nil : Seek::Config.n4h_username
      @url_publish = Seek::Config.n4h_publish_url.blank? ? nil : Seek::Config.n4h_publish_url
    end
    def publish_csh(project_transformed,token)
      content_length = project_transformed.bytesize
      headers = { content_type: 'application/json',Content_Length: content_length  ,Host: 'csh.nfdi4health.de', Authorization: 'Bearer ' + token
      }

      @endpoint = RestClient::Request.execute(method: :post, url: @url_publish, payload: project_transformed, headers: headers)
    end

    def send_transforming_api(project)
      @transformed = RestClient::Request.execute(method: :post, url: @url,payload: project, headers: { content_type: :json, accept: :json }).body
    end

    def get_token
      headers = {
        content_type: 'application/x-www-form-urlencoded'
      }
      payload = {
        client_secret: @password,
        grant_type: 'client_credentials',
        client_id: @username,
      }

      @token = RestClient::Request.execute(
        method: :post,
        url: @authorization_url,
        payload: payload,
        headers: headers
      )

    end

    def handle_restclient_error(e, name_server)
      case name_server
      when 'get_token'
        case e.response.code
        when 400
          'Token:CODE400- Bad Request: The server could not understand the request.'
        when 401
          'Token:CODE401- Unauthorized: Access is denied due to invalid credentials.'
        when 403
          'Token:CODE403- Forbidden: You do not have the necessary permissions to access this resource.'
        when 404
          'Token:CODE404- Not Found: The requested resource could not be found.'
        when 500
          'Token:CODE500- Internal Server Error: The server encountered an error and could not complete your request.'
        else
          "An unexpected error occurred: #{e.response}"
        end
      when 'send_transforming_api'
        case e.response.code
        when 400
          'Transorm:CODE400- Bad Request: The server could not understand the request.'
        when 401
          'Transorm:CODE401- Unauthorized: Access is denied due to invalid credentials.'
        when 403
          'Transorm:CODE403- Forbidden: You do not have the necessary permissions to access this resource.'
        when 404
          'Transorm:CODE404- Not Found: The requested resource could not be found.'
        when 500
          'Transorm:CODE500- Internal Server Error: The server encountered an error and could not complete your request.'
        else
          "An unexpected error occurred: #{e.response}"
        end
      when 'publish_csh'
        case e.response.code
        when 200
          'pub_csh:CODE200- No new draft version created because uploaded resource contains no changes'
        when 400
          'pub_csh:CODE400- Bad Request: The server could not understand the request.'
        when 401
          'pub_csh:CODE401- Not allowed to edit resource. User must either be the original creator of the resource or have been added as a collaborator.'
        when 403
          'pub_csh:CODE403- Forbidden: You do not have the necessary permissions to access this resource.'
        when 404
          'pub_csh:CODE404- Not Found: The requested resource could not be found.'
        when 422
          "#{JSON.parse(JSON.parse(e.response.to_json))['error']['message']}. Error(s) caused by: #{JSON.parse(JSON.parse(e.response.to_json))['error']['paths']}"
        when 500
          'pub_csh:CODE500- Internal Server Error: The server encountered an error and could not complete your request.'
        else
          "An unexpected error occurred: #{e.response}"
        end
      end
    end
  end

  class Preparation_json
    def initialize()

    end
    def transforming_api(project_find_id, serializer,type)
      @project = project_find_id
      project_attributes_json = serializer.new(@project).to_json

      #@user_current = current_person
      special_characters = {
        '\\u0026' => '__AMP__',
        '\\u003c' => '__LT__',
        '\\u003e' => '__GT__',
        '\\u0022' => '__QUOTE__'
      }

      # Replace special characters with placeholders
      special_characters.each do |char, placeholder|
        project_attributes_json.gsub!(char, placeholder)
      end
      project_attributes_json_parse = JSON.parse(project_attributes_json)

      meta_data = JSON.parse(@project.to_json(only:[:created_at,:updated_at, :uuid]))
      meta_data = meta_data.transform_keys { |key| key == 'created_at' ? 'created' : key }
      meta_data = meta_data.transform_keys { |key| key == 'updated_at' ? 'modified' : key }
      meta_data['api_version'] = ActiveModel::Serializer.config.api_version.to_s
      meta_data['base_url'] = Seek::Config.site_base_host
      meta_data = {meta: meta_data}
      project_attributes_json_parse['investigation']={}
      selected_keys = %w[project_administrators pals asset_housekeepers asset_gatekeepers organisms human_diseases people
                   institutions programmes investigations studies assays data_files project_relationships_json_files
                   file_templates placeholders models sops publications presentations events documents workflows
                   collections  submitter projects]
      project_relationships_json_parse = project_attributes_json_parse.select { |key, _| selected_keys.include?(key) }
      project_relationships_json = {relationships: project_relationships_json_parse}

      selected_keys.each do |item|
        project_attributes_json_parse.delete(item)
      end
      project_attributes_json = {attributes: project_attributes_json_parse}

      attributes_selected_json_parse = project_attributes_json.merge(project_relationships_json)
      attributes_selected_json_parse = attributes_selected_json_parse.merge(meta_data)
      attributes_selected_json_parse['id'] = @project.id.to_s
      attributes_selected_json_parse['type'] = type
      attributes_selected_json_parse['jsonapi'] = { 'version' => '1.0' }
      attributes_selected_json_parse['links'] = { 'self' => "/"+type+"/#{@project.id}"}
      attributes_selected_json_parse['relationships']={}
      user_attributes_selected_json_parse = {data: attributes_selected_json_parse}
      user_attributes_selected_json_parse
    end

    def header(endpoints, current_user_json,current_person)
      #@user_current = current_person
      special_characters = {
        '\\u0026' => '__AMP__',
        '\\u003c' => '__LT__',
        '\\u003e' => '__GT__',
        '\\u0022' => '__QUOTE__'
      }
      final_json_string = endpoints.to_json
      special_characters.each do |char, placeholder|
        final_json_string.gsub!(placeholder, char)
      end

      project_transformed_hash = JSON.parse(JSON.parse(final_json_string)['transformed'])



      project_transformed_update_hash = project_transformed_hash
      #current_person_json_parsed = JSON.parse(current_person.to_json)
      #selected_keys = ['first_name', 'last_name','email']
      #current_person_json_parsed_filtered = current_person_json_parsed.select { |key, _| selected_keys.include?(key) }
      contact_hash = {
        "contact" => {
          "name" => "#{current_person['first_name']} #{current_person['last_name']}",
          "email" => current_person['email']
        }
        }
      #current_person_json_parsed_filtered['login_id']=JSON.parse(current_user_json)['login']
      #sender_part = {contact: current_person_json_parsed_filtered }
      payload_project_merged = contact_hash.merge(project_transformed_update_hash)
      payload_project_merged
    end
  end

end
