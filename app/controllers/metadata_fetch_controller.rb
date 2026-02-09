require 'net/http'
require 'uri'
require 'json'
require 'openssl'

class MetadataFetchController < ApplicationController
  def fetch
    resource_id = params[:search]
    #source = params[:options]
    source = "GCHSH"

    @metadata = fetch_metadata_from_source(resource_id, source)
    if @metadata.present?
      flash[:notice] = "Metadata fetched from #{source} with ID #{resource_id}"
      @fetch_message = "Metadata fetched from #{source} with ID #{resource_id}"
      @fetch_status = :success
    else
      #flash[:alert] = "No data found from #{resource_id}"
      @fetch_message = "No metadata found for ID #{resource_id} in #{source}."
      @fetch_status = :error
    end
    respond_to do |format|
      format.js   # renders fetch.js.erb

      #format.html { render :fetch } # fallback
    end



    #render :show
  end

  private

  def fetch_metadata_from_source(resource_id, source)
    case source
    when "GCHSH"
      fetch_from_gchsh(resource_id)
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

  def fetch_from_clinical_gov(resource_id)
      #url = "https://clinicaltrials.gov/api/v2/studies/#{resource_id}?format=json"
      url = "https://health-study-hub.de/api/resource/#{resource_id}"
      get_json_from_url(url)
  end


  def get_json_from_url(url)
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == "https")
    # Timeouts
    http.open_timeout = 5
    http.read_timeout = 15

    # SSL: Default trust store (portable)
    if http.use_ssl?
      http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      store = OpenSSL::X509::Store.new
      store.set_default_paths
      http.cert_store = store
    end
      #http.ca_file = '/etc/ssl/certs/ca-certificates.crt'

    request = Net::HTTP::Get.new(uri.request_uri)
    request["Accept"] = "application/json"
    response = http.request(request)

    unless response.is_a?(Net::HTTPSuccess)
      Rails.logger.warn("Metadata fetch failed: url=#{url} status=#{response.code} body=#{response.body.to_s[0,500]}")
      return nil
    end
    JSON.parse(response.body)

  rescue JSON::ParserError => e
    Rails.logger.warn("Invalid JSON from url=#{url}: #{e.class}: #{e.message}")
    nil
  rescue StandardError => e
    Rails.logger.warn("HTTP error url=#{url}: #{e.class}: #{e.message}")
    nil
  end

end
