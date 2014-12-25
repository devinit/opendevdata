module Api
  module V1
    module OpenWorkspaces
      class DocumentsController < ApplicationController
        before_action :get_workspace
        respond_to :json

        def index
          respond_with @workspace.documents
        end

        def show
          respond_with @workspace.documents.find params[:id]
          rescue Mongoid::Errors::DocumentNotFound
            render json: { errors: "Document cannot be found!"}, status: 422
        end

        private

        def get_workspace
          @workspace = OpenWorkspace.find params[:open_workspace_id]
          rescue Mongoid::Errors::DocumentNotFound
            render json: { errors: "The workspace you are searching for could not be found!"}, status: 422
        end

      end
    end
  end
end
