# frozen_string_literal: true

class TimeEntry < ApplicationRecord
  belongs_to :user, inverse_of: :time_entries
  belongs_to :task, inverse_of: :time_entries
  has_one :project, through: :task
  has_one :organization, through: :project

  scope :in_organization, ->(org) { joins(:project).where(projects: { organization_id: org.id }) }
  scope :in_time_view, ->(tv) { in_organization(tv.organization).where(executed_on: tv.date) }
  scope :in_time_view_week_including, (lambda do |tv|
    in_organization(tv.organization)
      .where('executed_on >= ?', tv.date.beginning_of_week)
      .where('executed_on <= ?', tv.date.end_of_week)
  end)

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

  delegate :name, to: :project, prefix: true

  def self.total_amount
    sum(:amount)
  end

  def notes?
    notes.present?
  end

  def time_view
    TimeView.find executed_on.strftime(TimeView::ID_FORMAT), organization
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
end
