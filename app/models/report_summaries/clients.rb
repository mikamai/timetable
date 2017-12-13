# frozen_string_literal: true

module ReportSummaries
  class Clients < Base
    Row = Struct.new(:client, :amount)
    class Row
      delegate :name, to: :client
    end

    def rows
      amount_by_client = time_entries.includes(:project).group(:client_id).sum(:amount)
      clients = Client.where(id: amount_by_client.keys)
      amount_by_client.map do |k, v|
        Row.new(clients.detect { |p| p.id == k }, v)
      end
    end
  end
end
