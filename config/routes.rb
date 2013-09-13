Opendataportal::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    get "register", to: "devise/registrations#new", as: :register
    get "login", to: "devise/sessions#new", as: :login
    get "logout", to: "devise/sessions#destroy", as: :logout
  end

  match "/datasets/uploads/*path" => 'gridfs#serve'

  root to: 'pages#index'
end
