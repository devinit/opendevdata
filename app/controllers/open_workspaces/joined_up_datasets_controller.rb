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

  def process_types_of_data
    @joined_up_dataset = @workspace.joined_up_datasets.find_by id: params[:id]
    choice_value = params[:choice_value]
    column = params[:column]
    search_index = nil

    @joined_up_dataset.data_extract[:header_definitions].each_with_index do |key, index|
      search_index = index if key[:column] == column
    end

    @joined_up_dataset.data_extract[:header_definitions][search_index][:types_of_data] = choice_value if !search_index.nil?
    @joined_up_dataset.save

    render json: @joined_up_dataset
  end

  def process_formats_of_data
    @joined_up_dataset = @workspace.joined_up_datasets.find_by id: params[:id]
    choice_value = params[:choice_value]
    column = params[:column]
    search_index = nil

    @joined_up_dataset.data_extract[:header_definitions].each_with_index do |key, index|
      search_index = index if key[:column] == column
    end

    @joined_up_dataset.data_extract[:header_definitions][search_index][:format_type] = choice_value if !search_index.nil?

    @joined_up_dataset.save

    render json: @joined_up_dataset
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
    @joined_up_dataset = JoinedUpDataset.find params[:id]
  end

  def index
    @joined_up_datasets = @workspace.joined_up_datasets.where pending: false
  end

  def destroy
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
