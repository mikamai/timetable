# frozen_string_literal: true

module ReportSummaries
  class Projects < Base
    Row = Struct.new(:project, :amount)
    class Row
      delegate :name, to: :project
    end

    def rows
      amount_by_project = time_entries.group(:project_id).sum(:amount)
      projects = Project.where(id: amount_by_project.keys)
      amount_by_project.map do |k, v|
        Row.new(projects.detect { |p| p.id == k }, v)
      end
    end
  end
end
