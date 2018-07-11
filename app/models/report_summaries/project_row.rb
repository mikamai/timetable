# frozen_string_literal: true

module ReportSummaries
  class ProjectRow < BaseRow
    def self.build_from_scope scope
      group = scope.group(:project_id).sum(:amount)
      projects = Project.with_deleted.where(id: group.keys)
      build_from_grouped_amount group, projects
    end

    def name
      resource.full_name
    end

    def archived?
      resource.deleted?
    end
  end
end
