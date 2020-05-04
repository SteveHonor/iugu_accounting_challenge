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
      @account.movements.create!(
        kind: :credit,
        amount: account_params[:balance]
      )

      render json: {
        id: @account.id,
        token: token
      }, status: :created, location: @account
    else
      render json: @account.errors, status: :unprocessable_entity
    end
  end

  def balance
    render json: {
      balance: Account.find(params[:account_id]).balance
    }, status: :ok
  rescue
    render json: {
      error: 'account not exist'
    }, status: :unprocessable_entity and return
  end

  private

  def account_params
    params.require(:account).permit(:id, :name, :balance)
  end
end
