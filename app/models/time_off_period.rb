# frozen_string_literal: true

class TimeOffPeriod < ApplicationRecord
  belongs_to :user, inverse_of: :time_off_periods
  belongs_to :organization, inverse_of: :time_off_periods
  has_many :time_off_entries, dependent: :destroy
  accepts_nested_attributes_for :time_off_entries

  validates :typology,
    presence: true,
    inclusion: { in: %w(paid sick vacation) }
  validates :start_date,
    presence: true
  validates :end_date,
    presence: true
  validates_associated :time_off_entries
  validate :end_date_cannot_come_before_start_date

  delegate :name, to: :user, prefix: true, allow_nil: true

  def add_errors error_params
    errors = error_params[:errors]
    errors.keys.each { |k| self.errors.add(k, errors[k].join(', ')) }
  end

  def update_entries attributes
    self.time_off_entries.each { |entry| entry.update(attributes) }
  end

  def friendly_typology
    case self.typology
    when 'sick' then 'sick leave'
    else 'vacation'
    end
  end

  private

  def end_date_cannot_come_before_start_date
    return if start_date.blank? || end_date.blank?
    errors.add(:end_date, 'cannot come before start date') if end_date < start_date
  end
end
