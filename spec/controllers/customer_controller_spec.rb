require 'rails_helper'

RSpec.describe CustomersController, type: :controller do
  let(:create_customer) {
    post :create, params:  {
      customer: {
        name: Faker::Name.name,
        email: Faker::Internet.email,
        password: Faker::Number.number(digits: 6).to_s,
        document: Faker::CPF.numbers
      }
    }
  }

  let(:all_customers) {
    Customer.all
  }

  describe 'POST #create' do
    context 'when create customers' do
      it 'returns http success' do
        create_customer
        expect(response).to have_http_status(:success)
      end

      it 'returns one customers' do
        create_customer
        all_customers
        expect(all_customers.size).to eq(1)
      end
    end
  end
end
