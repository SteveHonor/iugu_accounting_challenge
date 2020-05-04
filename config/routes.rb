Rails.application.routes.draw do
  # Customers
  post 'customers', controller: :customers,      action: :create, as: :customer

  # Authentication
  post 'auth',      controller: :authentication, action: :auth

  # Account
  post 'accounts',  controller: :accounts,       action: :create, as: :account
  # Movement
  post 'transfer',  controller: :movements, action: :transfer, as: :movement
end
