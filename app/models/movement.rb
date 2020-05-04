class Movement < ApplicationRecord
  belongs_to :account

  enum kind: %i[
    credit
    debit
  ].freeze

  class << self
    def create_debit account_id: nil, amount: 0
      self.create!(
        kind: :debit,
        account_id: account_id,
        amount: -amount
      )

      set_balance(account_id)
    end

    def create_credit account_id: nil, amount: 0
      self.create!(
        kind: :credit,
        account_id: account_id,
        amount: amount
      )

      set_balance(account_id)
    end

    private

    def set_balance(account_id)
      account = Account.find(account_id)
      account.update!(balance: account.movements.sum(:amount))
    end
  end
end
