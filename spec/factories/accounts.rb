FactoryBot.define do
  factory :account do
    id       { Faker::Bank.account_number }
    name     { Faker::Bank.name }
    balance  { Faker::Number.decimal }
    customer factory: :customer
  end
end
