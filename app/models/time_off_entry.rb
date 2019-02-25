class TimeOffEntry < ApplicationRecord
  include HoursAmount

  add_hours_amount_to :amount

  belongs_to :user, inverse_of: :time_off_entries
  belongs_to :organization, inverse_of: :time_off_entries
  has_one :time_off_period

  scope :in_organization, ->(org) { where organization_id: org.id }
  scope :executed_by, ->(user) { where user_id: user.id }
  scope :executed_on, ->(date) { where executed_on: date }
  scope :by_executed_on, -> { order "executed_on ASC" }
  scope :paid, -> { where typology: 'paid' }
  scope :sick, -> { where typology: 'sick' }
  scope :vacation, -> { where typology: 'vacation' }

  validates :typology,
            presence: true,
            inclusion: { in: %w(paid sick vacation) }
  validates :executed_on,
            presence: true
  validates :amount,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              allow_nil:    true
            }
  validates :notes,
            presence: true,
            if: :is_paid_leave?

  delegate :name, to: :user, prefix: true, allow_nil: true

  def self.policy_class
    Organized::TimeOffEntryPolicy
  end

  def self.total_amount
    sum(:amount)
  end

  def is_paid_leave?
    typology.nil? || typology == 'paid'
  end

  def notes?
    notes.present?
  end

  def time_view
    TimeView.find executed_on.strftime(TimeView::ID_FORMAT), organization, user
  end

  def hours
    amount.to_f / 60
  end

  def approve
    update_status 'approved'
  end

  def decline
    update_status 'declined'
  end

  def authorize
    -> { authorize self }
  end

  def friendly_typology
    case self.typology
    when 'paid' then 'paid leave'
    when 'sick' then 'sick leave'
    else 'vacation'
    end
  end

  private

  def update_status status
    self.update({ status: status })    
  end
end
