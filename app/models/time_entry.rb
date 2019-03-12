# frozen_string_literal: true

# == Schema Information
#
# Table name: time_entries
#
#  id          :uuid             not null, primary key
#  amount      :integer          not null
#  executed_on :date             not null
#  notes       :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :uuid             not null
#  task_id     :uuid             not null
#  user_id     :uuid             not null
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#  fk_rails_...  (task_id => tasks.id)
#  fk_rails_...  (user_id => users.id)
#


class TimeEntry < ApplicationRecord
  include HoursAmount
  WEEK_ID_FORMAT = '%G-%V'

  add_hours_amount_to :amount

  belongs_to :user, inverse_of: :time_entries
  belongs_to :project, -> { with_deleted }, inverse_of: :time_entries
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

  private

  def validate_project_in_user_organization
    return if user.nil? || project.nil? || user.membership_in(project.organization)
    errors.add :project, :forbidden
  end

  def validate_task_in_project
    return if task.nil? || project.nil? || task.project_ids.include?(project.id)
    errors.add :task, :forbidden
  end
end
