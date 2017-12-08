# frozen_string_literal: true

class Task < ApplicationRecord
  belongs_to :project, inverse_of: :tasks
  has_many :time_entries, inverse_of: :task
  has_one :organization, through: :project

  scope :by_path, -> { joins(:project).order('projects.name', 'tasks.name') }

  validates :project_id,
            presence: true
  validates :name,
            presence: true,
            uniqueness: { scope: :project_id }

  def path
    "#{project.name} / #{name}"
  end
end
