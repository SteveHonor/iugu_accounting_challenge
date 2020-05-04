class MovementsController < ApplicationController
  before_action :authorize!
  before_action :check_amount, only: :transfer

  def transfer
    Movement.transaction do
      begin
        Movement.create_debit(
          account_id: origin_account.id,
          amount:     account_params[:amount].to_number
        )

        Movement.create_credit(
          account_id: destination_account.id,
          amount:     account_params[:amount].to_number
        )

        render json: {
          message: 'transfer successfully'
        }, status: :ok
      rescue
        raise ActiveRecord::Rollback
      end
    end
  end

  private

  def account_params
    params.require(:movement).permit(:source_account_id, :destination_account_id, :amount)
  end

  def origin_account
    Account.find(account_params[:source_account_id])
  rescue
    render json: {
      error: 'source account not exist'
    }, status: :unprocessable_entity and return
  end

  def destination_account
    Account.find(account_params[:destination_account_id])
  rescue
    render json: {
      error: 'destination account not exist'
    }, status: :unprocessable_entity and return
  end

  def check_amount
    return unless origin_account.present?
    return unless destination_account.present?

    amount_is_greater_than_zero?
    origin_has_limit?
  end

  def amount_is_greater_than_zero?
    render json: {
      error: 'amount must be greater than 0'
    }, status: :unprocessable_entity and return if account_params[:amount].nil? || account_params[:amount].to_f <= 0
  end

  def origin_has_limit?
    amount = account_params[:amount].to_f * -1
    if origin_account
      render json: {
        error: "source account has no available limit"
      }, status: :not_acceptable and return if origin_account.check_not_limit(amount)
    end
  end
end
