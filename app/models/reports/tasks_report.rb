# frozen_string_literal: true

module Reports
  class TasksReport < BaseReport
    Row = Struct.new(:task, :amount)
    class Row
      delegate :name, to: :task
    end

    def rows
      amount_by_task = time_entries.group(:task_id).sum(:amount)
      tasks = Task.where(id: amount_by_task.keys)
      amount_by_task.map do |k, v|
        Row.new(tasks.detect { |p| p.id == k }, v)
      end
    end
  end
end
