# frozen_string_literal: true

module Organized
  class ReportEntriesExportPolicy < BasePolicy
    def show?
      admin? || user == record.user
    end
  end
end
