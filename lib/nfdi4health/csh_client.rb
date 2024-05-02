require 'rest-client'

module Nfdi4Health

  class Client

    def initialize(endpoint)
      #@endpoint = RestClient::Resource.new(endpoint)


    end

    def publish_csh(project_transformed,url,token)
      content_length = project_transformed.bytesize
      headers = { content_type: 'application/json',Content_Length: content_length  ,Host: 'csh.nfdi4health.de', Authorization: "Bearer " + token
      }

      @endpoint = RestClient::Request.execute(method: :post, url: url, payload: project_transformed, headers: headers)
    end

    def send_transforming_api(project,url)
      #raise project.inspect
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

  end
end
