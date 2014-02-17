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

  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    resources :users
    match 'users/:id/ban', to: 'users#ban', as: :ban_user, via: :post
    match 'users/:id/unban', to: 'users#unban', as: :unban_user, via: :post
    match 'users/:id/make_admin', to: 'users#make_admin', as: :make_admin, via: :post
    match 'users/:id/remove_admin', to: 'users#remove_admin', as: :remove_admin, via: :post
    get 'admin/', to: 'pages#admin', as: :admin
  end

  get '/fs/uploads/:model/:field/:fid/:handle' => 'gridfs#serve', handle: /.*/

  concern :sociable, Sociable

  resources :datasets, concerns: :sociable
  get "delete_dataset/:id", to: 'datasets#delete_page', as: 'delete_dataset'

  resources :documents, concerns: :sociable

  namespace :api do
    namespace :v1 do
      # API routes
      resources :documents, only: [:index, :show]
      resources :datasets, only: [:index, :show]
    end
  end
end
