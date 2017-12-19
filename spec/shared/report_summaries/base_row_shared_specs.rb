# frozen_string_literal: true

require 'spec_helper'

RSpec.shared_examples 'ReportSummaries::BaseRow' do
  describe '| ::build_from_grouped_amount' do
    it 'returns a list of instances' do
      resource = OpenStruct.new id: 1
      res = described_class.build_from_grouped_amount({ 1 => 100 }, [resource])
      expect(res).to be_a Array
      expect(res.count).to eq 1
      instance = res[0]
      expect(instance).to be_a described_class
      expect(instance.amount).to eq 100
      expect(instance.resource).to eq resource
      expect(instance.name).to eq resource.name
    end
  end
end
