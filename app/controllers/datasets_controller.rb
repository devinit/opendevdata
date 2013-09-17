class DatasetsController < ApplicationController
  before_filter :authenticate_user!, except: :index

  def index
    @datasets = Dataset.page params[:page]
  end

  def show
    @dataset = Dataset.find params[:id]
  end

  def new
    @dataset = Dataset.new
  end

  def create
    @dataset = Dataset.create dataset_params
    if @dataset.save
      redirect_to @dataset, notice: "You have successfully uploaded a dataset"
    else
      flash[:alert] = "The dataset you have could not be uploaded."
      render "new"
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
    def dataset_params
      params.require(:dataset).permit(:name, :description)
    end

end
