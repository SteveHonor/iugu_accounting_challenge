class Customer < ApplicationRecord

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

  validates_presence_of :name, :email, :document, :password_digest
end
