# frozen_string_literal: true

class TimeOffPeriod < ApplicationRecord
  belongs_to :user, inverse_of: :time_off_periods
  belongs_to :organization, inverse_of: :time_off_periods
  has_many :time_off_entries, dependent: :destroy

  validates :typology,
    presence: true
  validates :start_date,
    presence: true
  validates :end_date,
    presence: true

  delegate :name, to: :user, prefix: true, allow_nil: true

  def friendly_typology
    case self.typology
    when 'sick' then 'sick leave'
    else 'vacation'
    end
  end
end
