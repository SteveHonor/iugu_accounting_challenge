require 'rails_helper'
require 'jwt'

RSpec.describe AccountsController, type: :controller do
  let(:customer) {
    FactoryBot.create(:customer)
  }

  let(:account) {
    FactoryBot.create(:account, id: '123456')
  }

  let(:account_default_id) {
    post :create, params:  {
      account: {
        id: '123456',
        name: Faker::Bank.name,
        balance: Faker::Number.decimal,
      }
    }
  }

  let(:account_with_id) {
    post :create, params:  {
      account: {
        id: Faker::Bank.account_number,
        name: Faker::Bank.name,
        balance: Faker::Number.decimal,
      }
    }
  }

  let(:account_without_id) {
    post :create, params:  {
      account: {
        name: Faker::Bank.name,
        balance: Faker::Number.decimal,
      }
    }
  }

  let(:token) {
    JWT.encode({
      customer_id: customer.id
    }, Rails.application.secrets.secret_key_base.to_s)
  }

  describe 'POST #create' do
    context 'when create account with id' do
      before(:each) do
        customer

        request.headers.merge!({
          "Authorization": token
        })

        account_with_id
      end

      it 'return http success' do
        expect(response).to have_http_status(:success)
      end

      it 'return one account' do
        expect(Account.all.size).to eq(1)
      end

      it 'return a object of account wiht number account and token' do
        expect(JSON.parse(response.body).keys).to match(%w[
          id token
        ])
      end
    end

    context 'when create account without id' do
      before(:each) do
        customer

        request.headers.merge!({
          "Authorization": token
        })

        account_without_id
      end

      it 'return http success' do
        expect(response).to have_http_status(:success)
      end

      it 'return one account' do
        expect(Account.all.size).to eq(1)
      end

      it 'return a object of account wiht number account and token' do
        expect(JSON.parse(response.body).keys).to match(%w[
          id token
        ])
      end
    end

    context 'when create duplicated account with default id' do
      before(:each) do
        customer

        request.headers.merge!({
          "Authorization": token
        })

        account
      end

      it 'return http unprocessable entity' do
        account_default_id
          expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'return a id exeption' do
        account_default_id
        expect(JSON.parse(response.body).keys).to match(%w[
          id
        ])
      end

      it 'return unprocessable entity message' do
        account_default_id
        expect(JSON.parse(response.body)['id']).to eq(["has already been taken"])
      end

      it 'returns one account' do
        account_default_id
        expect(Account.all.size).to eq(1)
      end
    end

    context 'when create account fail' do
      before(:each) do
        customer

        request.headers.merge!({
          "Authorization": 'invalid_token'
        })

        account_with_id
      end

      it 'return http unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'return zero account' do
        expect(Account.all.size).to eq(0)
      end
    end
  end

  describe 'GET #balance' do
    context 'when return balance' do
      let(:account) {
        FactoryBot.create(:account, id: '123456', balance: '1.200,00'.to_number)
      }

      before(:each) do
        customer

        request.headers.merge!({
          "Authorization": token
        })

        account
      end

      it 'return account balance' do
        get :balance, params: {
          account_id: '123456'
        }

        expect(JSON.parse(response.body)['balance']).to eq('R$1.200,00')
      end
    end
  end
end
