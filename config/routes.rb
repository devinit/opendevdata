require 'ckeditor'
require 'resque_web'

Opendataportal::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  resque_web_constraint = lambda  do |request|
    current_user = request.env['warden'].user
    current_user.present? && current_user.respond_to?(:is_admin?) && current_user.is_admin?
  end
  constraints resque_web_constraint do
    mount ResqueWeb::Engine => '/resque_web'
  end

  devise_for :users
  devise_scope :user do
    get "register", to: "devise/registrations#new", as: :register
    get "login", to: "devise/sessions#new", as: :login
    get "logout", to: "devise/sessions#destroy", as: :logout
  end

  get '/fs/uploads/:model/:field/:fid/:handle' => 'gridfs#serve', handle: /.*/

  root to: 'pages#index'

  concern :sociable, Sociable

  resources :datasets, concerns: :sociable
  resources :posts, concerns: :sociable
end
