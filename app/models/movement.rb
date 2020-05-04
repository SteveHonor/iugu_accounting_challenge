class Movement < ApplicationRecord
  belongs_to :account

  enum kind: %i[
    credit
    debit
  ].freeze

end
