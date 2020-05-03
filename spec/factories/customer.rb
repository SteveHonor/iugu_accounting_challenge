FactoryBot.define do
  factory :customer do
    name     { Faker::Name.name }
    email    { Faker::Internet.email }
    password { Faker::Number.number(digits: 6).to_s }
    document { Faker::CPF.numbers }
  end
end
