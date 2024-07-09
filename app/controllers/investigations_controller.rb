require 'nfdi4health/csh_client'
class InvestigationsController < ApplicationController

  include Seek::IndexPager
  include Seek::DestroyHandling
  include Seek::AssetsCommon

  before_action :investigations_enabled?
  before_action :find_assets, :only=>[:index]
  before_action :find_and_authorize_requested_item,:only=>[:edit, :manage, :update, :manage_update, :destroy, :show,:new_object_based_on_existing_one]

  #project_membership_required_appended is an alias to project_membership_required, but is necesary to include the actions
  #defined in the application controller
  before_action :project_membership_required_appended, :only=>[:new_object_based_on_existing_one]

  before_action :check_studies_are_for_this_investigation, only: %i[update]

  include Seek::Publishing::PublishingCommon

  include Seek::AnnotationCommon

  include Seek::IsaGraphExtensions

  api_actions :index, :show, :create, :update, :destroy

  def new_object_based_on_existing_one
    @existing_investigation =  Investigation.find(params[:id])
    if @existing_investigation.can_view?
      @investigation = @existing_investigation.clone_with_associations
      render :action=>"new"
    else
      flash[:error]="You do not have the necessary permissions to copy this #{t('investigation')}"
      redirect_to @existing_investigation
    end

  end

  def export_isatab_json
    the_hash = IsaTabConverter.convert_investigation(Investigation.find(params[:id]))
    send_data JSON.pretty_generate(the_hash) , filename: 'isatab.json'
  end

  def export_isa
    isa = IsaExporter::Exporter.new(Investigation.find(params[:id]), current_user).export
    send_data isa, filename: 'isa.json', type: 'application/json', deposition: 'attachment'
  rescue Exception => e
    respond_to do |format|
      flash[:error] = e.message
      format.html { redirect_to investigation_path(Investigation.find(params[:id])) }
    end
  end

  def show
    @investigation=Investigation.find(params[:id])

    respond_to do |format|
      format.html { render(params[:only_content] ? { layout: false } : {})}
      format.rdf { render :template=>'rdf/show' }
      format.json {render json: @investigation}

      format.ro do
        ro_for_download
      end

    end
  end

  def ro_for_download
    ro_file = Seek::ResearchObjects::Generator.new(@investigation).generate
    send_file(ro_file.path,
              type:Mime::Type.lookup_by_extension("ro").to_s,
              filename: @investigation.research_object_filename)
    headers["Content-Length"]=ro_file.size.to_s
  end

  def create
    @investigation = Investigation.new(investigation_params)
    update_sharing_policies @investigation
    update_annotations(params[:tag_list], @investigation)
    update_relationships(@investigation, params)

    if @investigation.save
      respond_to do |format|
        flash[:notice] = "The #{t('investigation')} was successfully created."
        format.html { redirect_to params[:single_page] ?
          single_page_path(id: params[:single_page], item_type: 'investigation', item_id: @investigation) 
          : investigation_path(@investigation) }
        format.json { render json: @investigation }
      end
    else
      respond_to do |format|
        format.html { render :action => "new" }
        format.json { render json: json_api_errors(@investigation), status: :unprocessable_entity }
      end
    end
  end

  def edit
    respond_to do |format|
      format.html
    end
  end

  def order_studies
    @investigation = Investigation.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  def update
    @investigation=Investigation.find(params[:id])
    if params[:investigation]&.[](:ordered_study_ids)
      a1 = params[:investigation][:ordered_study_ids]
      a1.permit!
      pos = 0
      a1.each_pair do |key, value |
        disable_authorization_checks {
          study = Study.find (value)
          study.position = pos
          pos += 1
          study.save!
        }
      end
      respond_to do |format|
        format.html { redirect_to(@investigation) }
      end
    else
      @investigation.update(investigation_params)
      update_sharing_policies @investigation
      update_annotations(params[:tag_list], @investigation)
      update_relationships(@investigation, params)

      respond_to do |format|
        if @investigation.save
          flash[:notice] = "#{t('investigation')} was successfully updated."
          format.html {redirect_to(@investigation)}
          format.json {render json: @investigation}
        else
          format.html {render :action => 'edit'}
          format.json {render json: json_api_errors(@investigation), status: :unprocessable_entity}
        end
      end
    end
  end

  def publish_to_csh
    @investigation = Investigation.find(params[:id])
    password = Seek::Config.n4h_password
    url = Seek::Config.n4h_url.blank? ? nil : Seek::Config.n4h_url
    authorization_url = Seek::Config.n4h_authorization_url.blank? ? nil : Seek::Config.n4h_authorization_url
    username = Seek::Config.n4h_username.blank? ? nil : Seek::Config.n4h_username
    url_publish = Seek::Config.n4h_publish_url.blank? ? nil : Seek::Config.n4h_publish_url

    data_investigation = Nfdi4Health::Preparation_json.new
    transforming_api_data = data_investigation.transforming_api(Investigation.find(params[:id]), InvestigationSerializer, 'investigation')

    begin
      endpoints = Nfdi4Health::Client.new()
      endpoints.send_transforming_api(transforming_api_data.to_json, url)
    rescue RestClient::ExceptionWithResponse => e
      flash[:error] = if e.response
                        "HTTP Status: #{e.response.code} - #{e.response.body}"
                      else
                        "RestClient::ExceptionWithResponse occurred without a response: #{e.message}"
                      end
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end

      return
    rescue RestClient::RequestTimeout => e
      flash[:error] = 'Request Timeout: The server took too long to respond.'
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    rescue SocketError => e
      flash[:error] = 'Network Error: Please check your internet connection.'
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    rescue StandardError => e
      flash[:error] = "An unexpected error occurred: #{e.message}"
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    end

    sender_investigation_merged=data_investigation.header(endpoints, @current_user.to_json,current_person)
    begin
      endpoints.get_token(authorization_url,username,password)
    rescue RestClient::ExceptionWithResponse => e
      flash[:error] = endpoints.handle_restclient_error(e,'get_token')
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    rescue RestClient::RequestTimeout
      flash[:error] = 'Request Timeout: The server took too long to respond.'
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    rescue SocketError
      flash[:error] = 'Network Error: Please check your internet connection.'
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    rescue StandardError => e
      flash[:error] = "An unexpected error occurred: #{e.message}"
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    end
    token_respond_hash = JSON.parse(endpoints.to_json)
    access_token = token_respond_hash['token']
    access_token_hash = JSON.parse(access_token)
    one_time_token = access_token_hash['access_token']
    begin
      endpoints.publish_csh(sender_investigation_merged.to_json,url_publish,one_time_token)
    rescue RestClient::ExceptionWithResponse => e
      flash[:error] = endpoints.handle_restclient_error(e,'publish_csh')
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    rescue RestClient::RequestTimeout
      flash[:error] = 'Request Timeout: The server took too long to respond.'
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    rescue SocketError
      flash[:error] = 'Network Error: Please check your internet connection.'
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    rescue StandardError => e
      flash[:error] = "An unexpected error occurred: #{e.message}"
      respond_to do |format|
        format.html { redirect_to(@investigation) }
        format.rdf { render template: 'rdf/show' }
        format.json { render json: { error: flash[:error] }, status: :unprocessable_entity }
      end
      return
    end
    if !JSON.parse(JSON.parse(endpoints.to_json)['endpoint'])['resource'].nil?
      identifier = JSON.parse(JSON.parse(endpoints.to_json)['endpoint'])['resource']['identifier']
      if !sender_investigation_merged['resource']['identifier'].nil?
        flash[:notice] ="#{t('investigation')} was successfully updated with ID #{identifier}."
      else
        flash[:notice] ="#{t('investigation')} was successfully published with ID #{identifier}."
        em = @investigation.extended_metadata
        jem = JSON.parse(em.json_metadata)
        jem['Resource_identifier_Investigation'] = identifier
        em.update_column(:json_metadata, jem.to_json)
      end
    else
      flash[:notice] = JSON.parse(JSON.parse(endpoints.to_json)['endpoint'])
    end

    respond_to do |format|
      format.html { redirect_to(@investigation) }
      format.rdf { render template: 'rdf/show' }
      format.json { render json: @investigation, include: [params[:include]] }
    end
  end


  private

  def investigation_params
    params.require(:investigation).permit(:title, :description, { project_ids: [] }, *creator_related_params,
                                          :position, { publication_ids: [] },
                                          :is_isa_json_compliant,
                                          { discussion_links_attributes:[:id, :url, :label, :_destroy] },
                                          { extended_metadata_attributes: determine_extended_metadata_keys })
  end

  def check_studies_are_for_this_investigation
    investigation_id = params[:id]
    if params[:investigation][:ordered_study_ids]
      a1 = params[:investigation][:ordered_study_ids]
      a1.permit!
      valid = true
      a1.each_pair do |key, value |
        a = Study.find (value)
        valid = valid && !a.investigation.nil? && a.investigation_id.to_s == investigation_id
      end
      unless valid
        error("Each ordered #{"Study"} must be associated with the Investigation", "is invalid (invalid #{"Study"})")
        return false
      end
    end
    return true
  end


end
