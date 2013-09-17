require 'ckeditor'

Opendataportal::Application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'
  devise_for :users
  devise_scope :user do
    get "register", to: "devise/registrations#new", as: :register
    get "login", to: "devise/sessions#new", as: :login
    get "logout", to: "devise/sessions#destroy", as: :logout
  end

  match "uploads/grid/*path" => 'gridfs#serve'

  root to: 'pages#index'

  resources :datasets

  resources :posts do
    resources :comments
  end

end
