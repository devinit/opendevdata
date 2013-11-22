require 'ckeditor'
require 'sidekiq/web'

Opendataportal::Application.routes.draw do
  root 'pages#index'
  get "about", to: 'pages#about', as: :about

  mount Ckeditor::Engine => '/ckeditor'
  mount Opendata::API => "/"

  authenticate :user, lambda { |u| u.is_admin? } do
    mount Sidekiq::Web => '/sidekiq'
    get "users/", to: "users#index", as: :users
    get 'user/:id', to: 'users#show', as: :user
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  devise_scope :user do
    get "register", to: "devise/registrations#new", as: :register
    get "login", to: "devise/sessions#new", as: :login
    get "logout", to: "devise/sessions#destroy", as: :logout
  end

  get '/fs/uploads/:model/:field/:fid/:handle' => 'gridfs#serve', handle: /.*/

  concern :sociable, Sociable

  resources :datasets, concerns: :sociable
  get "delete_dataset/:id", to: 'datasets#delete_page', as: 'delete_dataset'
  resources :posts, concerns: :sociable
  get "blog", to: 'posts#index', as: :blog
end
