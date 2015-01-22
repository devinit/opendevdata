class DataSeriesController < ApplicationController
  before_action :authenticate_user!, except: [:create_endpoint, :index]

  def index
    @data_series = DataSerie.all
    respond_to do |format|
      format.html
      format.json { render json: DataSerie.pluck(:name) }
    end
  end

  def show
  end

  def edit
  end

  def new
    @data_serie = DataSerie.new
  end

  def create_endpoint
    if signed_in?
      name = params[:name]
      description = params[:description]
      logger.info "OVER HERE"
      @data_serie = DataSerie.new
      @data_serie.name = name
      @data_serie.description = description
      if @data_serie.save
        render json: @data_serie, status: :created, location: @data_serie
      else
        render json: @data_serie.errors, status: :unprocessable_entity
      end
    else
      render json: {error: "You can't POST here unless you have signed in!"}
    end
  end

  def create
    @data_serie = DataSerie.create data_series_params

    respond_to do |format|
      if @data_serie.save
        format.html { redirect_to @data_serie, notice: "Data serie has been created"}
        format.json { render json: @data_serie, status: :created, location: @data_serie }
      else
        format.html { render :action => "new"}
        format.json { render json: @data_serie.errors, status: :unprocessable_entity }
      end
    end
  end


  private
    def data_series_params
      params.require(:data_serie).permit(:name, :description)
    end

end
