require 'sidekiq/web'

Opendataportal::Application.routes.draw do
  root 'pages#index'
  get "about", to: 'pages#about', as: :about
  get "developer", to: 'pages#developer', as: :developer

  devise_for :users

  devise_scope :user do
    get "register", to: "devise/registrations#new", as: :register
    get "login", to: "devise/sessions#new", as: :login
    get "logout", to: "devise/sessions#destroy", as: :logout
  end

  # authenticate :user do
  #   resources :open_workspaces, only: :show do
  #     resources :messages, only: [:index, :show, :new, :create]
  #   end
  # end

  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    resources :users
    resources :open_workspaces  # do everything
    match 'users/:id/ban', to: 'users#ban', as: :ban_user, via: :post
    match 'users/:id/unban', to: 'users#unban', as: :unban_user, via: :post
    match 'users/:id/make_admin', to: 'users#make_admin', as: :make_admin, via: :post
    match 'users/:id/remove_admin', to: 'users#remove_admin', as: :remove_admin, via: :post
    match 'workspaces/:id/approve', to: 'open_workspaces#approve', as: :approve_workspace, via: :post
    match 'unapproved-workspaces', to: 'open_workspaces#unapproved', as: :unapproved_workspaces, via: :get
    get 'admin/', to: 'pages#admin', as: :admin
  end

  get '/fs/uploads/:model/:field/:fid/:handle' => 'gridfs#serve', handle: /.*/

  concern :sociable, Sociable

  resources :datasets, concerns: :sociable # all datasets

  get 'my-workspaces', to: 'open_workspaces#my_workspaces', as: :my_workspaces

  match 'open_workspaces/:id/apply-to-join', to: 'open_workspaces#apply_to_join', as: :apply_to_join, via: :post
  match 'open_workspaces/:id/pending', to: 'open_workspaces#pending', as: :pending, via: :get
  match 'leave/workspaces/:id', to: 'open_workspaces#leave_workspace', via: :delete, as: :leave_workspace
  match 'open_workspaces/:id/blogs', to: 'open_workspaces#blogs', as: :blog, via: :get

  match 'open_workspaces/messages', to: 'messages#create', via: :post

  resources :open_workspaces do
    resources :memberships, only: [:show] do
      member do
        get 'approve'
        post 'approve'
      end
    end
    resources :datasets, concerns: :sociable, controller: 'open_workspaces/datasets'
    resources :documents, concerns: :sociable, controller: 'open_workspaces/documents'
  end

  get "delete_dataset/:id", to: 'datasets#delete_page', as: 'delete_dataset'

  resources :documents, concerns: :sociable
  get 'activity', to: 'pages#activities', as: 'activity'

  namespace :api do
    namespace :v1 do
      # API routes
      resources :documents, only: [:index, :show]
      resources :datasets, only: [:index, :show]

      # resources :workspaces, only: [:index, :show] do
      #   resources :documents, only: [:index, :show]
      #   resources :datasets, only: [:index, :show]
      # end
    end
  end
end
