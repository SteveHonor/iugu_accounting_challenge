class ApplicationController < ActionController::API
  def authorize!
    begin
      @decoded = decode(token)
    rescue ActiveRecord::RecordNotFound => e
      render json: {
        errors: e.message
      }, status: :unauthorized
    rescue JWT::DecodeError => e
      render json: {
        errors: e.message
      }, status: :unauthorized
    end
  end

  def current_customer
    @current_client = Customer.find(@decoded[:customer_id])
  end

  protected

  def encode(payload)
    JWT.encode(payload, secret_key)
  end

  def decode(token)
    JWT.decode(token, secret_key).first.symbolize_keys
  end

  private

  def secret_key
    @secret_key ||= Rails.application.secrets.secret_key_base.to_s
  end

  def token
    request.headers['Authorization']&.split(' ')&.last || ''
  end
end
