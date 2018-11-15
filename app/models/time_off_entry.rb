class TimeOffEntry < ApplicationRecord
  include HoursAmount

  add_hours_amount_to :amount

  belongs_to :user, inverse_of: :time_entries
  has_one :organization, through: :user

  validates :executed_on,
            presence: true
  validates :amount,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              less_than_or_equal_to: 8,
              allow_nil:    true
            }

  delegate :name, to: :user, prefix: true, allow_nil: true
end
