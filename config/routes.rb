require 'ckeditor'
require 'sidekiq/web'

Opendataportal::Application.routes.draw do
  root 'pages#index'

  mount Ckeditor::Engine => '/ckeditor'

  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
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
end
