module Api
  module V1
    class DatasetsController < ApplicationController
      before_filter :get_dataset, only: [:show]
      respond_to :json

      def index
        respond_with Dataset.all
      end

      def show
        respond_with @dataset
      end

      private

      def get_dataset
        @dataset = Dataset.find(slugs=params[:id]) # we are using slugs!
        # @dataset = Dataset.find_by_slug! params[:id]
        rescue Mongoid::Errors::DocumentNotFound
          render json: { errors: "The dataset you are searching for could not be found!"}, status: 422
      end

    end
  end
end
