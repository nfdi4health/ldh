require 'net/http'
require 'uri'
require 'json'

class MetadataFetchController < ApplicationController
  def fetch
    resource_id = params[:search]
    source = params[:options]

    @metadata = fetch_metadata_from_source(resource_id, source)
    if @metadata
      flash[:notice] = "Metadata fetched from #{source} with ID #{resource_id}"
    else
      flash[:alert] = "No data found from #{resource_id}"
    end
    respond_to do |format|
      #format.js   # renders fetch.js.erb

      format.html { render :fetch } # fallback
    end



    #render :show
  end

  private

  def fetch_metadata_from_source(resource_id, source)
    case source
    when "GCHSH"
      fetch_from_gchsh(resource_id)
    when "DRKS"
      fetch_from_drks(resource_id)
    when "clinical.gov"
      fetch_from_clinical_gov(resource_id)
    else
      nil
    end
  end
def fetch_from_gchsh(resource_id)
    url = "https://health-study-hub.de/api/resource/#{resource_id}"
    get_json_from_url(url)
  end

  def fetch_from_drks(resource_id)
    url = "https://drks.de/api/v1/trials/#{resource_id}"
    get_json_from_url(url)
  end

  def fetch_from_clinical_gov(resource_id)
    url = "https://clinicaltrials.gov/api/v2/studies/#{resource_id}?format=json"
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
