require 'rails_helper'

RSpec.describe MovementsController, type: :controller do
  let!(:customer) {
    FactoryBot.create_list(:customer, 2)
  }

  let!(:accounts) {
    FactoryBot.create(:account, customer: Customer.first, balance: 100)
    FactoryBot.create(:account, customer: Customer.last,  balance: 100)
  }

  let(:token) {
    JWT.encode({
      customer_id: Customer.first.id
    }, Rails.application.secrets.secret_key_base.to_s)
  }

  describe 'POST #transfer' do
    before(:each) do
      request.headers.merge!({
        "Authorization": token
      })
    end

    context 'when transfer value between accounts with balance' do
      let!(:movements) {
        post :transfer, params:  {
          movement: {
            source_account_id: Account.all[0].id,
            destination_account_id: Account.all[1].id,
            amount: 10
          }
        }
      }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end
    end

    context 'when transfer value between accounts without balance' do
      let!(:movements) {
        post :transfer, params:  {
          movement: {
            source_account_id: Account.all[0].id,
            destination_account_id: Account.all[1].id,
            amount: 200
          }
        }
      }

      it 'returns transfer error' do
        expect(JSON.parse(response.body).keys).to match(%w[error])
      end

      it 'return no limit error message' do
        expect(JSON.parse(response.body)['error']).to eq('source account has no available limit')
      end
    end

    context 'when transfer with nonexistent source account' do
      let!(:movements) {
        post :transfer, params:  {
          movement: {
            source_account_id: 0000,
            destination_account_id: Account.all[1].id,
            amount: 20
          }
        }
      }

      it 'returns transfer error' do
        expect(JSON.parse(response.body).keys).to match(%w[error])
      end

      it 'return source account error message' do
        expect(JSON.parse(response.body)['error']).to eq('source account not exist')
      end
    end

    context 'when transfer with nonexistent destination account' do
      let!(:movements) {
        post :transfer, params:  {
          movement: {
            source_account_id: Account.all[0].id,
            destination_account_id: 0000,
            amount: 20
          }
        }
      }

      it 'returns transfer error' do
        expect(JSON.parse(response.body).keys).to match(%w[error])
      end

      it 'return destination account error message' do
        expect(JSON.parse(response.body)['error']).to eq('destination account not exist')
      end
    end
  end
end
