module Api
  module V1
    class OpenWorkspacesController < ApplicationController
      before_filter :get_workspace, only: [:show]
      respond_to :json

      def index
        respond_with OpenWorkspace.all
      end

      def show
        respond_with @workspace
      end

      private

      def get_workspace
        @workspace = OpenWorkspace.find params[:id]
        rescue Mongoid::Errors::DocumentNotFound
          render json: { errors: "The workspace you are searching for could not be found!"}, status: 422
      end

    end
  end
end
