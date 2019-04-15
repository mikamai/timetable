# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportSummaries::TaskRow do
  it_behaves_like 'ReportSummaries::BaseRow'

  describe '::build_from_scope' do
    it 'returns a list of instances' do
      te = create :time_entry
      res = described_class.build_from_scope TimeEntry
      expect(res).to be_a Array
      expect(res.length).to eq 1
      expect(res[0].amount).to eq te.amount
      expect(res[0].resource).to eq te.task
    end

    it 'sums all entries of the same task' do
      te = create :time_entry, amount: 1
      p = create :project, organization: te.organization, users: [te.user]
      te.task.projects << p
      te.task.reload
      create :time_entry, amount: 2, organization: te.organization,
             task: te.task, project: p, user: te.user
      res = described_class.build_from_scope TimeEntry
      expect(res.length).to eq 1
      expect(res[0].amount).to eq 3
    end

    it 'does not sum entries of different projects' do
      te = create :time_entry, amount: 1
      create :time_entry, amount: 2, organization: te.organization
      res = described_class.build_from_scope TimeEntry
      expect(res.length).to eq 2
      expect(res.map(&:amount)).to match_array [1, 2]
    end
  end
end
