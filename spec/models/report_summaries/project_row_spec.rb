# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportSummaries::ProjectRow do
  it_behaves_like 'ReportSummaries::BaseRow'

  describe '::build_from_scope' do
    it 'returns a list of instances' do
      te = create :time_entry
      res = described_class.build_from_scope TimeEntry
      expect(res).to be_a Array
      expect(res.length).to eq 1
      expect(res[0].amount).to eq te.amount
      expect(res[0].resource).to eq te.project
    end

    it 'sums all entries of the same project' do
      u = create :user, :organized
      p = create :project, :with_tasks, tasks_count: 2, organization: u.organizations.first, users: [u]
      create :time_entry, amount: 1, organization: p.organization,
             project: p, task: p.tasks.first, user: u
      create :time_entry, amount: 2, organization: p.organization,
             project: p, task: p.tasks.last, user: u
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
