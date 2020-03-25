Rails.application.routes.draw do
  post 'authenticate', to: 'authentications#authenticate'

  resources :books
end
