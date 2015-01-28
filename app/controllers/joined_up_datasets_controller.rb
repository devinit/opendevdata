class JoinedUpDatasetsController < ApplicationController
  def index
    @joined_up_datasets = JoinedUpDataset.desc(:created_at)
  end
end
