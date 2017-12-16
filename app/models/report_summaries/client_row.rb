# frozen_string_literal: true

module ReportSummaries
  class ClientRow < BaseRow
    def self.build_from_scope scope
      group = scope.includes(:project)
                   .group(:client_id)
                   .sum(:amount)
      clients = Client.where(id: group.keys)
      build_from_grouped_amount group, clients
    end
  end
end
