Rails.application.routes.draw do
  resources :customers
  post 'auth',      controller: :authentication, action: :auth
end
