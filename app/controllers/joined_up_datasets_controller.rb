class JoinedUpDatasetsController < ApplicationController
  def index
    @joined_up_datasets = JoinedUpDataset.all
  end
end
