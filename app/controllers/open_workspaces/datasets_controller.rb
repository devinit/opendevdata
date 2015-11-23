class OpenWorkspaces::DatasetsController < ApplicationController
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update, :destroy]
  before_filter :get_workspace
  before_filter :grant_access!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @datasets = @workspace.datasets.all

    @tags = []

    @datasets.each do |dataset|
        dataset.tags.split(",").each do |tag|
          @tags << tag
        end
    end

    if params[:search].nil?
      @datasets = @datasets.desc(:created_at).page(params[:page])
    else
      @datasets = @datasets.search(params[:search]).uniq.delete_if { |dataset| dataset.nil? or dataset.empty? }
    end
  end

  def new
    @dataset = Dataset.new
  end

  def create
    @dataset= Dataset.create dataset_params.merge(user: current_user,
                                                  open_workspace: @workspace)
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
      # redirect_to [@workspace, @dataset], notice: "You've successfully uploaded a dataset"
      redirect_to open_workspace_dataset_path(@workspace, @dataset), notice: "You've successfully uploaded a dataset"
    else
      flash[:alert] = "Failed to save"
      render "new"
    end
  end

  def show
    @dataset = @workspace.datasets.find params[:id]
    @comments = @dataset.comments.page(params[:page])
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
  end

  def edit
    @dataset = @workspace.datasets.find params[:id]
  end

  def update
    @dataset = @workspace.datasets.find params[:id]
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

      redirect_to open_workspace_dataset_path(@workspace, @dataset)
    else
      flash[:alert] = 'Could not update your dataset. Contact Admin'
      render "edit"
    end
  end

  def destroy
    if has_change_access? @workspace, current_user
      @dataset = @workspace.datasets.find params[:id]
      @dataset.destroy
    end
  end

  private
    def get_workspace
      @workspace = OpenWorkspace.find params[:open_workspace_id]
    end

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

    def grant_access!
      if !@workspace.memberships.where(user: current_user, approved: true).exists?
        redirect_to root_path, alert: "You don't have permission to do this"
      end
    end


end
