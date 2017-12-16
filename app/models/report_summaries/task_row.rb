# frozen_string_literal: true

module ReportSummaries
  class TaskRow < BaseRow
    def self.build_from_scope scope
      group = scope.group(:task_id).sum(:amount)
      tasks = Task.where(id: group.keys)
      build_from_grouped_amount group, tasks
    end
  end
end
