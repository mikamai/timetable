# frozen_string_literal: true

class TimeOffPeriod < ApplicationRecord
  attr_accessor :duration

  belongs_to :user, inverse_of: :time_off_periods
  belongs_to :organization, inverse_of: :time_off_periods
  has_many :time_off_entries, dependent: :destroy
  accepts_nested_attributes_for :time_off_entries

  scope :by_start_date, -> { order "start_date ASC" }
  scope :paid, -> { where typology: 'paid' }
  scope :sick, -> { where typology: 'sick' }
  scope :vacation, -> { where typology: 'vacation' }

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

  before_save :set_duration

  def self.policy_class
    Organized::TimeOffPeriodPolicy
  end

  def self.total_days
    sum(:duration)
  end

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

  def approve
    update_status_to_self_and_children 'approved'
  end

  def decline
    update_status_to_self_and_children 'declined'
  end

  private

  def end_date_cannot_come_before_start_date
    return if start_date.blank? || end_date.blank?
    errors.add(:end_date, 'cannot come before start date') if end_date < start_date
  end

  def set_duration
    self.duration = self.time_off_entries.length
  end

  def update_status_to_self_and_children status
    self.update_entries({ status: status })
    self.update({ status: status })
  end
end
