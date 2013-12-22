class DatasetsController < ApplicationController
  layout "ordinary_application"
  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :get_dataset, only: [:edit, :show, :update, :destroy]

  def get_dataset
    @dataset = Dataset.find(slug=params[:id])  # we are using slugs!
    rescue Mongoid::Errors::DocumentNotFound
      flash[:alert] = "The dataset you were looking for could not be found."
      redirect_to datasets_path
  end

  def default_serializer_options
    {root: false}
  end

  def index
    @datasets = Dataset.desc(:created_at).page(params[:page])
    respond_to do |format|
      format.html
      format.json { render json: @datasets }
      format.csv { send_data @datasets.to_csv}
    end
  end

  # def download_csv_all
  #   @dataset = Dataset.to_csv
  # end

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
    @dataset.view_count += 1
    @dataset.save # save view count

    respond_to do |format|
      format.html
      format.json { render json: @dataset }
    end

  end

  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.create(dataset_params.merge(user: current_user))
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
    if current_user.is_admin? or is_owner_of(@dataset)
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
        :data_units,
        :tags)
    end

end
