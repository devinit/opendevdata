class DatasetsController < ApplicationController

  before_filter :authenticate_user!, except: [:index, :show]
  before_filter :get_dataset, only: [:edit, :show, :update, :destroy]

  def get_dataset
    @dataset = Dataset.find(slugs=params[:id]) # we are using slugs!
    # @dataset = Dataset.find_by_slug! params[:id]
    rescue Mongoid::Errors::DocumentNotFound
      flash[:alert] = "The dataset you were looking for could not be found."
      redirect_to datasets_path
  end

  def default_serializer_options
    {root: false}
  end

  def index
    @tags = []
    Dataset.tags.each do |tag|
      @tags << tag
    end

    if params[:search].nil?
      @datasets = Dataset.desc(:created_at).page(params[:page])
    else
      @datasets = Dataset.search(params[:search]).uniq.delete_if { |dataset| dataset.nil? or dataset.empty? }
    end

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
    data_extract = @dataset.data_extract
    @chart_type ||= @dataset.chart_type
    if @chart_type == ""
      @chart_type = nil
    end

    if !@chart_type.nil? and !data_extract.nil?
      @chart = LazyHighCharts::HighChart.new('graph') do |f|

        f.title(:text => @dataset.title)
        f.xAxis(:categories => data_extract['headings'], title:{ text: @dataset.x_label, margin: 70 })
        data_extract['data_values'].each do |d|
          f.series(name: d['name'], yAxis: 0, data: d['data'])
        end
        f.yAxis [
          {:title => {:text => @dataset.y_label, :margin => 70} },
          # {:title => {:text => "Population in Millions"}, :opposite => true},
        ]

        f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
        f.chart({:defaultSeriesType=>@chart_type})
      end
    end

    @comments = @dataset.comments.desc(:created_at).page(params[:page])
    if signed_in?
      if @dataset.user != current_user
        @dataset.view_count += 1
        @dataset.save # save view count
      end
    else
      @dataset.view_count += 1
      @dataset.save # save view count
    end

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
      if !@dataset.no_viz and dataset_params['attachment']
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
    if current_user
      if @dataset.user == current_user or current_user.is_admin?
        render "edit"
      else
        flash[:alert] =  "You can't edit this document."
        redirect_to datasets_path
      end
    else
      flash[:alert] = "You don't have the right permissions to edit this file"
      redirect_to datasets_path
    end
  end

  def update
    if @dataset.user == current_user or current_user.is_admin?
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
  end

  def delete_page
    @dataset = Dataset.find params[:id]
  end

  def destroy
    @dataset = Dataset.find params[:id]
    if current_user.is_admin? or is_owner_of(@dataset)
      @dataset.delete
      flash[:notice] = 'Successfully deleted dataset.'
    else
      flash[:alert] = "Could not delete this dataset because you don't have the permission to."
    end
    redirect_to datasets_path
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
        :no_viz,
        :sub_title,
        :title,
        :data_units,
        :tags)
    end

end
