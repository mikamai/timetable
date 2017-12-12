# frozen_string_literal: true

class TimeEntry < ApplicationRecord
  belongs_to :user, inverse_of: :time_entries
  belongs_to :project, inverse_of: :time_entries
  belongs_to :task, inverse_of: :time_entries
  has_one :organization, through: :project

  scope :in_organization, ->(org) { joins(:project).where(projects: { organization_id: org.id }) }
  scope :executed_on, ->(date) { where executed_on: date }
  scope :executed_since, ->(date) { where 'executed_on >= ?', date }
  scope :executed_until, ->(date) { where 'executed_on <= ?', date }
  scope :executed_by, ->(user) { where user_id: user.id }

  validates :user_id,
            presence: true
  validates :task_id,
            presence: true
  validates :executed_on,
            presence: true
  validates :amount,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              allow_nil:    true
            }
  validate  :validate_task_in_user_organization, on: :create

  after_validation :copy_errors_to_minutes_in_distance

  delegate :name, to: :project, prefix: true

  def self.total_amount
    sum(:amount)
  end

  def notes?
    notes.present?
  end

  def time_view
    TimeView.find executed_on.strftime(TimeView::ID_FORMAT), organization, user
  end

  def minutes_in_distance
    return nil unless amount
    hours = amount / 60
    minutes = amount % 60
    "#{hours}:#{minutes.to_s.rjust 2, '0'}"
  end

  def minutes_in_distance= val
    match = val.match(/\A(\d+)\:(\d+)\z/)
    val = match[1].to_i * 60 + match[2].to_i if match
    assign_attributes amount: val
  end

  private

  def validate_task_in_user_organization
    return if user.organizations.pluck(:id).include? task.organization.id
    errors.add :task, :not_found
  end

  def copy_errors_to_minutes_in_distance
    errors[:amount].each { |e| errors.add :minutes_in_distance, e }
  end
end
