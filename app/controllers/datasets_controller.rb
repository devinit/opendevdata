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
    @datasets = Dataset.desc(:created_at).page(params[:page])
  end

  def show
    if @dataset.data_extract
      gon.data_values ||= @dataset.data_extract['data_values']
      gon.headings_gon ||= @dataset.data_extract['headings']
      gon.chartTitle ||= @dataset.title
      gon.subTitle ||= @dataset.sub_title
      gon.yLabel ||= @dataset.y_label
      gon.xLabel ||= @dataset.x_label
      gon.data_units ||= @dataset.data_units
    end
    @chart_type ||= @dataset.chart_type
    @comments = @dataset.comments.desc(:created_at).page(params[:page])
  end

  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.create dataset_params
    if @dataset.save
      # send file for processing
      if dataset_params['attachment']
        _id = @dataset.id.to_s
        ExcelToJson.perform_async(
          _id,
          dataset_params['attachment'].tempfile.path,
          dataset_params['chart_type'],
          @dataset.attachment.path.split("/").last)
      end

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
      if dataset_params['attachment']
        _id = @dataset.id.to_s
        # TODO refactor and put this in dataset.rb
        ExcelToJson.perform_async(
          _id,
          dataset_params['attachment'].tempfile.path,
          dataset_params['chart_type'],
          @dataset.attachment.path.split("/").last)
      end
      redirect_to @dataset, notice: "You have successfully updated this dataset."
    else
      flash[:alert] = "The dataset you have could not be updated."
      render "edit"
    end
  end

  def delete_page
    @dataset = Dataset.find params[:id]
  end

  def destroy
    if current_user.has_role? :admin
      @dataset.delete
      flash[:notice] = 'Successfully deleted dataset.'
    else
      flash[:alert] = "Could not delete this dataset because you don't have the permission to."
    end
    redirect_to dataset_path
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
