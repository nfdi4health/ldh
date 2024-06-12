require 'rest-client'

module Nfdi4Health

  class Client
    attr_accessor :transformed

    def publish_csh(project_transformed,url,token)
      content_length = project_transformed.bytesize
      headers = { content_type: 'application/json',Content_Length: content_length  ,Host: 'csh.nfdi4health.de', Authorization: 'Bearer ' + token
      }

      @endpoint = RestClient::Request.execute(method: :post, url: url, payload: project_transformed, headers: headers)
    end

    def send_transforming_api(project,url)
      @transformed = RestClient::Request.execute(method: :post, url: url,payload: project, headers: { content_type: :json, accept: :json }).body
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
          JSON.parse(JSON.parse(e.response.to_json)["message"])
        when 500
          'pub_csh:CODE500- Internal Server Error: The server encountered an error and could not complete your request.'
        else
          "An unexpected error occurred: #{e.response}"
        end
      end
    end
  end
end
