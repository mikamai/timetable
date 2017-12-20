# frozen_string_literal: true

class TimeEntry < ApplicationRecord
  WEEK_ID_FORMAT = '%G-%V'

  belongs_to :user, inverse_of: :time_entries
  belongs_to :project, inverse_of: :time_entries
  belongs_to :task, inverse_of: :time_entries
  has_one :organization, through: :project
  has_one :client, through: :project

  scope :in_organization, ->(org) { joins(:project).where(projects: { organization_id: org.id }) }
  scope :executed_on, ->(date) { where executed_on: date }
  scope :executed_since, ->(date) { where 'executed_on >= ?', date }
  scope :executed_until, ->(date) { where 'executed_on <= ?', date }
  scope :executed_by, ->(user) { where user_id: user.id }

  validates :executed_on,
            presence: true
  validates :amount,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              allow_nil:    true
            }
  validate  :validate_project_in_user_organization, on: :create
  validate  :validate_task_in_project, on: :create

  delegate :name, to: :project, prefix: true, allow_nil: true
  delegate :name, to: :client, prefix: true, allow_nil: true
  delegate :name, to: :task, prefix: true, allow_nil: true
  delegate :name, to: :user, prefix: true, allow_nil: true

  def self.policy_class
    Organized::TimeEntryPolicy
  end

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
    return @minutes_in_distance if @minutes_in_distance
    return nil unless amount
    hours = amount / 60
    minutes = amount % 60
    "#{hours}:#{minutes.to_s.rjust 2, '0'}"
  end

  def minutes_in_distance= val
    @minutes_in_distance = val
    match = val.to_s.match(/\A(\d+)(:(\d+))?\z/)
    val = match[1].to_i * 60 + (match[3] || '').to_i if match
    assign_attributes amount: val
  end

  private

  def validate_project_in_user_organization
    return if user.nil? || project.nil? || user.membership_in(project.organization)
    errors.add :project, :forbidden
  end

  def validate_task_in_project
    return if task.nil? || project.nil? || project.task_ids.include?(task.id)
    errors.add :task, :forbidden
  end
end
