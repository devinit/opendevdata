module Api
  module V1
    class DatasetsController < ApplicationController
      respond_to :json

      def index
        respond_with Dataset.all
      end

      def show
        respond_with Dataset.find params[:id]
      end
    end
  end
end
