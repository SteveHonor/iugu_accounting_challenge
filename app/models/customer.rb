class Customer < ApplicationRecord
  has_secure_password
  has_one :account

  validates_uniqueness_of :email, case_sensitive: true

  validates :email,
   presence: true,
   format: {
    with: URI::MailTo::EMAIL_REGEXP
  }

  validates :password, length: {
    minimum: 6
    }, if: -> {
      new_record? || !password.nil?
  }

  validates_presence_of :name, :document, :password_digest
end
