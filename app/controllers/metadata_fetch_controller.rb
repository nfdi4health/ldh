require 'net/http'
require 'uri'
require 'json'

class MetadataFetchController < ApplicationController
  def fetch
    resource_id = params[:search]
    source = params[:options]

    @metadata = fetch_from_gchsh(resource_id)
    if @metadata
      flash[:notice] = "Metadata fetched from health study hub with ID #{resource_id}"
    else
      flash[:alert] = "No data found from #{resource_id}"
    end
    respond_to do |format|
      #format.js   # renders fetch.js.erb

      format.html { render :fetch } # fallback
    end



    #render :show
  end


def fetch_from_gchsh(resource_id)
    url = "https://health-study-hub.de/api/resource/#{resource_id}"
    get_json_from_url(url)
  end


  def get_json_from_url(url)
    uri = URI.parse(url)
    response = Net::HTTP.get_response(uri)

    if response.is_a?(Net::HTTPSuccess)
      JSON.parse(response.body)
    else
      nil
    end
  end
end
