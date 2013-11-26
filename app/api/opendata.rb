module Opendata
  class API < Grape::API
    version 'v1', using: :header, vendor: 'opendata'
    format :json

    helpers do
      def current_user
        @current_user ||= User.authorize!(env)
      end

      def authenticate!
        error!('401 Unauthorized', 401) unless current_user
      end
    end

    resources :datasets do

      desc "Return all datasets"
      get :all do
        Dataset.limit(10)
      end

      desc "Return a single dataset"
      params do
        requires :id, type: String, desc: "Dataset id"
      end
      route_param :id do
        get do
          Dataset.find(slug=params[:id])
          rescue Mongoid::Errors::DocumentNotFound
            logger.info "mongo document can't be found"
          end
        end
      end

      # desc "Create a dataset"
      # params do
      #   # TODO
      # end

    end
  end
end
