class AccountsController < ApplicationController
  before_action :authorize!

  def create
    @account = Account.new(
      id: account_params[:id],
      name: account_params[:name],
      balance: account_params[:balance],
      customer: current_customer
    )

    if @account.save
      render json: {
        id: @account.id,
        token: token
      }, status: :created, location: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  private

  def account_params
    params.require(:account).permit(:id, :name, :balance)
  end
end
