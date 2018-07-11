# frozen_string_literal: true

module ReportSummaries
  class BaseRow
    def self.build_from_scope _scope
      raise NotImplementedError
    end

    def self.build_from_grouped_amount group, resources
      group.map do |k, v|
        resource = resources.detect { |r| r.id == k }
        new(resource, v)
      end
    end

    attr_reader :resource, :amount

    def initialize resource, amount
      @resource = resource
      @amount = amount
    end

    def name
      resource.name
    end

    def archived?
      false
    end
  end
end
