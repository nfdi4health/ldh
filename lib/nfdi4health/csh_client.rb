require 'rest-client'

module Nfdi4Health

  class Client
    attr_accessor :transformed
    def initialize(endpoint)
      #@endpoint = RestClient::Resource.new(endpoint)


    end

    def publish_csh(project_transformed,url,token)
      #escaped_string=ERB::Util.html_escape(project_transformed)
      content_length = project_transformed.bytesize
      headers = { content_type: 'application/json',Content_Length: content_length  ,Host: 'csh.nfdi4health.de', Authorization: 'Bearer ' + token
      }

      @endpoint = RestClient::Request.execute(method: :post, url: url, payload: project_transformed, headers: headers)
    end

    def send_transforming_api(project,url)
      #raise project.inspect
      #escaped_string=ERB::Util.html_escape(project)
      @transformed = RestClient::Request.execute(method: :post, url: url,payload: project, headers: { content_type: :json, accept: :json }).body
      #@endpoint['publish'].post(project, content_type: 'application/json')
    end



    def get_token(url,user,password)
      headers = {
        content_type: 'application/x-www-form-urlencoded'
      }
      payload = {
        client_secret: password,
        grant_type: 'client_credentials',
        client_id: user,
      }

      @token = RestClient::Request.execute(
        method: :post,
        url: url,
        payload: payload,
        headers: headers
      )

    end
    def handle_restclient_error(e, name_server)
      case name_server
      when 'get_token'
        case e.response.code
        when 400
          'Bad Request: The server could not understand the request.'
        when 401
          'Unauthorized: Access is denied due to invalid credentials.'
        when 403
          'Forbidden: You do not have the necessary permissions to access this resource.'
        when 404
          'Not Found: The requested resource could not be found.'
        when 500
          'Internal Server Error: The server encountered an error and could not complete your request.'
        else
          "An unexpected error occurred: #{e.response}"
        end
      when 'send_transforming_api'
        case e.response.code
        when 400
          'Bad Request: The server could not understand the request.'
        when 401
          'Unauthorized: Access is denied due to invalid credentials.'
        when 403
          'Forbidden: You do not have the necessary permissions to access this resource.'
        when 404
          'Not Found: The requested resource could not be found.'
        when 500
          'Internal Server Error: The server encountered an error and could not complete your request.'
        else
          "An unexpected error occurred: #{e.response}"
        end
      when 'publish_csh'
        case e.response.code
        when 200
          'No new draft version created because uploaded resource contains no changes'
        when 400
          'Bad Request: The server could not understand the request.'
        when 401
          'Not allowed to edit resource. User must either be the original creator of the resource or have been added as a collaborator.'
        when 403
          'Forbidden: You do not have the necessary permissions to access this resource.'
        when 404
          'Not Found: The requested resource could not be found.'
        when 422
          JSON.parse(JSON.parse(e.response.to_json)["message"])
        when 500
          'Internal Server Error: The server encountered an error and could not complete your request.'
        else
          "An unexpected error occurred: #{e.response}"
        end
      end
    end
  end
end