class Workspaces::DatasetsController < ApplicationController
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
                                                  workspace: @workspace)
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
      redirect_to workspace_dataset_path(@workspace, @dataset), notice: "You've successfully uploaded a dataset"
    else
      flash[:alert] = "Failed to save"
      render "new"
    end
  end

  def show
    @dataset = @workspace.datasets.find params[:id]
    @comments = @dataset.comments.all
    data_exract = @dataset.data_extract
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
    if @chart_type == ""
      @chart_type = nil
    end

    @chart = LazyHighCharts::HighChart.new('graph') do |f|
      f.title(:text => @dataset.title)
      f.xAxis(:categories => ["United States", "Japan", "China", "Germany", "France"])
      f.series(:name => "GDP in Billions", :yAxis => 0, :data => [14119, 5068, 4985, 3339, 2656])
      f.series(:name => "Population in Millions", :yAxis => 1, :data => [310, 127, 1340, 81, 65])

      f.yAxis [
        {:title => {:text => "GDP in Billions", :margin => 70} },
        {:title => {:text => "Population in Millions"}, :opposite => true},
      ]

      f.legend(:align => 'right', :verticalAlign => 'top', :y => 75, :x => -50, :layout => 'vertical',)
      f.chart({:defaultSeriesType=>"column"})
    end

  end

  def edit
    @dataset = @workspace.datasets.find params[:id]
  end

  def update
    @dataset = @workspace.datasets.find params[:id]
    if @dataset.update_attributes dataset_params
      redirect_to workspace_dataset_path(@workspace, @dataset)
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
      @workspace = Workspace.find params[:workspace_id]
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
