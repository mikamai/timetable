# frozen_string_literal: true

class AddTaskToProject
  class << self
    def perform *args
      new(*args).perform
    end
  end

  attr_reader :project, :task

  def initialize project, task
    @project = project
    @task = task
  end

  def perform
    project.tasks << task
    project
  rescue ActiveRecord::RecordNotUnique
    project.errors.add :tasks, :taken
    project
  end
end
