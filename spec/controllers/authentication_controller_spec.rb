require 'rails_helper'

RSpec.describe AuthenticationController do
  let!(:customer) {
    FactoryBot.create(:customer)
  }

  describe 'POST #auth' do
    describe 'with correct credentials' do
      let!(:auth) {
        post :auth, params: {
          authentication: {
            email: customer.email,
            password: customer.password
          }
        }
      }

      it 'returns http success' do
        expect(response).to have_http_status(:success)
      end

      it 'returns JWT' do
        expect(JSON.parse(response.body).keys).to match(%w[token])
      end
    end

    describe 'with incorrect credentials' do
      let!(:auth) {
        post :auth, params: {
          authentication: {
            email: customer.email,
            password: '12345'}
          }
        }

      it 'returns http success' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'returns credentials error' do
        expect(JSON.parse(response.body).keys).to match(%w[error])
      end

      it 'return unauthorized error message' do
        expect(JSON.parse(response.body)['error']).to eq('unauthorized')
      end
    end
  end
end
