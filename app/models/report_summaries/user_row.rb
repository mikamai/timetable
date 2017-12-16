# frozen_string_literal: true

module ReportSummaries
  class UserRow < BaseRow
    def self.build_from_scope scope
      group = scope.group(:user_id).sum(:amount)
      users = User.where(id: group.keys)
      build_from_grouped_amount group, users
    end
  end
end
