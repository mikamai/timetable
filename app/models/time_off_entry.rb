class TimeOffEntry < ApplicationRecord
  include HoursAmount

  add_hours_amount_to :amount

  belongs_to :user, inverse_of: :time_entries
  belongs_to :organization

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

  def self.policy_class
    Organized::TimeOffEntryPolicy
  end

  def time_view
    TimeView.find executed_on.strftime(TimeView::ID_FORMAT), organization, user
  end
end
