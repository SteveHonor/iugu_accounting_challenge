Rails.application.routes.draw do
  # Customers
  post 'customers', controller: :customers, action: :create, as: :customer

  # Authentication
  post 'auth', controller: :authentication, action: :auth

  # Account
  post 'accounts',            controller: :accounts, action: :create, as: :account
  get  'balance/:account_id', controller: :accounts, action: :balance

  # Movement
  post 'transfer',  controller: :movements, action: :transfer, as: :movement
end
