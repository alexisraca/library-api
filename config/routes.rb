Rails.application.routes.draw do
  post 'authenticate', to: 'authentications#authenticate'

  resources :books, only: %i[index show update destroy create] do
    resources :pages, only: %i[show create]
  end
end
