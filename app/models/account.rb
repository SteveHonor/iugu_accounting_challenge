class Account < ApplicationRecord
  before_validation :generate_id, on: :create

  belongs_to :customer

  validates_uniqueness_of :id, case_sensitive: true
  validates :id, presence: true
  validates :name, presence: true

  private

  def generate_id
    self.id = Time.now.to_i if id.blank?
  end
end
