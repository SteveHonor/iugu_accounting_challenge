class AuthenticationController < ApplicationController
  before_action :set_customer, only: :auth
  before_action :authorize_request, except: :auth

  def auth
    if @customer&.authenticate(auth_params[:password])
      token = encode(customer_id: @customer.id)

      render json: {
        token: token
      }, status: :ok
    else
      render json: {
        error: :unauthorized
      }, status: :unauthorized
    end
  end

  private

  def set_customer
    @customer = Customer.find_by_email(auth_params[:email])
  end

  def auth_params
    params.require(:authentication).permit(:email, :password)
  end
end
