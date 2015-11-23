class OpenWorkspaces::JoinedUpDatasetsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :get_workspace

  # Some differences with how we are working with REST
  # - upload (a user will put in a CSV or use their existing excel utilities
  # to convert existing data to a CSV format (hopefully it will be standard
  # - to update a dataset, user basically has to attach a newer CVS file or
  # Delete the joined up dataset)
  def upload
  end

  def update
    logger.info "YOu are at update #{params}"
  end

  def import
    # TODO -> setup conditional validations
    joined_up_dataset = JoinedUpDataset.new
    # precautionary save
    joined_up_dataset.save
    set_joined_up_dataset_id(joined_up_dataset)
    joined_up_dataset.import params[:file], current_user, @workspace
    # redirect_to open_workspace_processing_url(@workspace)
    redirect_to open_workspace_joined_up_dataset_steps_path(@workspace)
  end

  def processing
  end

  def process_final_stage_of_upload
    @joined_up_dataset = current_joined_up_dataset

    data_serie_id = params[:data_series_id]
    if !data_serie_id.nil?
      # @joined_up_dataset.data_serie = DataSerie.find_by id: data_serie_id
      @joined_up_dataset.data_series_selected = true # Is there a better way??//querying existings of data_series?
      @joined_up_dataset.save
      render json: @joined_up_dataset
    else
      payload = {
          error: "You sent an erroneous data series ID",
          status: 400
            }
      render :json => payload, :status => :bad_request
    end
  end

  def process_types_of_data
    @joined_up_dataset = @workspace.joined_up_datasets.find_by id: params[:id]
    choice_value = params[:choice_value]
    column = params[:column]
    search_index = nil

    @joined_up_dataset.data_extract[:header_definitions].each_with_index do |key, index|
      search_index = index if key[:column] == column
    end

    @joined_up_dataset.data_extract[:header_definitions][search_index][:types_of_data] = choice_value if !search_index.nil?
    @joined_up_dataset.data_choice_made = true
    @joined_up_dataset.save

    render json: @joined_up_dataset
  end

  def add_data_series
    name = params[:name]
    key = params[:key]
    judu = JoinedUpDataset.find params[:id]

    #process key
    search_index = nil
    judu.data_extract[:header_definitions].each_with_index do |k, index|
      search_index = index if k[:key] == key.to_sym # we have to change string to symbol
    end

    if !search_index.nil?
      to_name = nil
      name_that = DataSerie.where(name: name).first
      if name_that.slug.nil?
        to_name = name
      else
        to_name = name_that.slug
      end

      judu.data_extract[:header_definitions][search_index][:data_serie_slug] = to_name
      judu.data_series_array << to_name if !name_that.slug.nil?
      # TODO -> remove duplicates in case a human wants to change mind
      judu.data_series_selected = true
      if judu.save
        render json: { ok: "You have attached a data serie to a joined up data set column", status: 200}
      else
        render json: {error: "Sorry, something went horibly wrong! Review your dataset", status: 400}, status: :bad_request
      end
      # not a classy solution (TODO -> fix)
    else
      render json: {error: "Sorry, something went horibly wrong! Review your dataset", status: 400}, status: :bad_request
    end
  end

  def process_formats_of_data
    # This method processes the format of data
    @joined_up_dataset = current_joined_up_dataset
    choice_value = params[:choice_value]
    column = params[:column]

    if choice_value == column
      # TODO -> provide error on same page if possible before click "continue"
      render json: {error: "You can't have two columns with the same value!", status: 400}, status: :bad_request
    else
      search_index = nil

      @joined_up_dataset.data_extract[:header_definitions].each_with_index do |key, index|
        search_index = index if key[:column] == column
      end

      @joined_up_dataset.data_extract[:header_definitions][search_index][:format_type] = choice_value if !search_index.nil?

      @joined_up_dataset.space_time_format_selected = true

      @joined_up_dataset.save

      render json: @joined_up_dataset
    end
  end

  def pending
    @pending = JoinedUpDataset.where pending: true
  end

  def prepare
    @joined_up_dataset = @workspace.joined_up_datasets.find params[:id]
    # keys are where we store the unique columns that the system
    # identifies in the dataset
    @keys = []
    @joined_up_dataset.data_extract['value_extract'].each do |val|
      val.keys().each do |_key|
        @keys << _key if !@keys.include?(_key)
      end
    end
    @column_keys = []
    @keys.each_with_index do |key, index|
      @column_keys << [key, ('A'..'Z').to_a[index]]
    end

  end

  def show
    @joined_up_dataset = @workspace.joined_up_datasets.find params[:id]
  end


  def destroy
    @joined_up_dataset = @workspace.joined_up_datasets.find params[:id]
    if current_user.is_admin? or @workspace.has_change_access? current_user
      # perform a soft delete
      @joined_up_dataset.delete
      redirect_to @workspace, notice: "You've successfully deleted the Joined Up dataset"
    else
      redirect_to  open_workspace_joined_up_dataset_path(@workspace, @joined_up_dataset.id),
        alert: "You don't have the permission to delete this dataset. Contact Administrator"
    end
  end

  def index
    @joined_up_datasets = @workspace.joined_up_datasets.where pending: false
  end

  def update
  end

  private
    def get_workspace
      @workspace = OpenWorkspace.find params[:open_workspace_id]
    end

    def set_joined_up_dataset_id joined_up_dataset
      session[:joined_up_dataset_id] = joined_up_dataset.id
    end

    def current_joined_up_dataset
      @joined_up_dataset ||= JoinedUpDataset.find_by id: session[:joined_up_dataset_id]
    end

end
