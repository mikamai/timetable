class ReportSummaryPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      return scope.time_entries.all if user.admin_in? scope.organization
      scope.time_entries.executed_by user
    end
  end
end
