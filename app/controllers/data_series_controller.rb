class DataSeriesController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
  end

  def edit
  end

  def new
    @data_serie = DataSerie.new
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
