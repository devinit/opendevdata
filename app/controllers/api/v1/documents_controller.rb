module Api
  module V1
    class DocumentsController < ApplicationController
      respond_to :json

      def index
        respond_with Document.all
      end

      def show
        respond_with Document.find params[:id]
      end
    end
  end
end
