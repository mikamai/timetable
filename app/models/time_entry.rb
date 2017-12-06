# frozen_string_literal: true

class TimeEntry < ApplicationRecord
  belongs_to :user, inverse_of: :time_entries
  belongs_to :project

  scope :in_organization, ->(org) { joins(:project).where(projects: { organization_id: org.id }) }
  scope :in_time_view, ->(tv) { in_organization(tv.organization).where(executed_on: tv.date) }
  scope :in_time_view_week_including, (lambda do |tv|
    in_organization(tv.organization)
      .where('executed_on >= ?', tv.date.beginning_of_week)
      .where('executed_on <= ?', tv.date.end_of_week)
  end)

  validates :user_id,
            presence: true
  validates :project_id,
            presence: true
  validates :executed_on,
            presence: true
  validates :minutes,
            presence: true,
            numericality: {
              only_integer: true,
              greater_than: 0,
              allow_nil:    true
            }

  delegate :name, to: :project, prefix: true
end
