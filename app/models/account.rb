class Account < ApplicationRecord
  before_validation :generate_id, on: :create

  belongs_to :customer
  has_many :movements

  validates_uniqueness_of :id, case_sensitive: true
  validates :id, presence: true
  validates :name, presence: true

  def has_limit? amount
    return self[:balance] >= amount
  end

  def balance
    self[:balance].to_real
  end

  private

  def generate_id
    self.id = Time.now.to_i if id.blank?
  end
end
