class DatasetsController < ApplicationController
  before_filter :authenticate_user!, except: :index
  before_filter :get_dataset, only: [:edit, :show, :update, :destroy]

  def get_dataset
    @dataset = Dataset.find(slug=params[:id])  # we are using slugs!
    rescue Mongoid::Errors::DocumentNotFound
      flash[:alert] = "The dataset you were looking for could not be found."
      redirect_to datasets_path
  end

  def index
    @datasets = Dataset.page params[:page]
  end

  def show
    # filename = @dataset.attachment.file.grid_file.as_document['filename']
    # perform some work to strip off values from dataset
    # DatasetWorker.perform_async(@dataset.id)
    # TODO Rescue from error when searchable object is not found.
  end

  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.create dataset_params
    if @dataset.save
      # send file for processing
      _id = @dataset.id.to_s

      Resque.enqueue(
        ExcelToJson,
        _id,
        dataset_params['attachment'].tempfile.path,
        dataset_params['chart_type'],
        @dataset.attachment.path.split("/").last)

      redirect_to @dataset, notice: "You have successfully uploaded a dataset"
    else
      flash[:alert] = "The dataset you have could not be uploaded."
      render "new"
    end
  end

  def edit
  end

  def update
    if @dataset.update_attributes dataset_params
      _id = @dataset.id.to_s
      # TODO refactor and put this in dataset.rb
      Resque.enqueue(
        ExcelToJson,
        _id,
        dataset_params['attachment'].tempfile.path,
        dataset_params['chart_type'],
        @dataset.attachment.path.split("/").last)
      redirect_to @dataset, notice: "You have successfully updated this dataset."
    else
      render "edit"
    end
  end

  def destroy
  end

  private
    def dataset_params
      params.require(:dataset).permit(
        :name,
        :description,
        :attachment,
        :chart_type,
        :x_label,
        :y_label,
        :sub_title,
        :title,
        :data_units)
    end

end
