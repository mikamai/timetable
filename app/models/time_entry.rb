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

  def hours
    amount.to_f / 60
  end

  def time_amount
    return @time_amount if @time_amount
    return nil unless amount
    hours = amount / 60
    minutes = amount % 60
    "#{hours}:#{minutes.to_s.rjust 2, '0'}"
  end

  def time_amount= val
    @time_amount = val
    assign_attributes amount: parse_time_amount(val)
  end

  private

  def validate_project_in_user_organization
    return if user.nil? || project.nil? || user.membership_in(project.organization)
    errors.add :project, :forbidden
  end

  def validate_task_in_project
    return if task.nil? || project.nil? || task.project_ids.include?(project.id)
    errors.add :task, :forbidden
  end

  def parse_time_amount val
    parse_time_float(val) || parse_time_string(val) || val
  end

  def parse_time_float val
    return nil unless val.to_s.match?(/^\d+([\.,]?\d+)$/)
    (val.to_s.sub(',', '.').to_f * 60).to_i
  end

  def parse_time_string val
    match = val.to_s.match(/\A(\d+)(:(\d+))?\z/)
    return match[1].to_i * 60 + (match[3] || '').to_i if match
  end
end
