# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExportReportEntriesJob do
  let(:organization) { create :organization }
  let(:user) { create :user, :organized, organization: organization }
  let(:report_entries_export) { create :report_entries_export, organization: organization, user: user }

  describe '#report_entries_for' do
    subject { described_class.new.report_entries_for report_entries_export }

    it 'returns a list' do
      expect(subject).to be_a ActiveRecord::Relation
    end

    it 'returns entries made by the given organization' do
      te = create :time_entry, organization: report_entries_export.organization, user: report_entries_export.user
      expect(subject).to include te
    end

    it 'does not include entries made by other users' do
      te = create :time_entry, organization: report_entries_export.organization
      expect(subject).not_to include te
    end

    context 'when export has been created by admin' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      it 'includes entries made by other users' do
        te = create :time_entry, organization: report_entries_export.organization
        expect(subject).to include te
      end
    end

    it 'additionally filter data' do
      te = create :time_entry, organization: report_entries_export.organization, user: report_entries_export.user
      create :time_entry, organization: report_entries_export.organization, user: report_entries_export.user, executed_on: 3.days.ago
      report_entries_export.assign_attributes export_query: { executed_on_gteq: 2.days.ago }
      expect(subject).to eq [te]
    end
  end

  describe '#create_report' do
    subject { described_class.new.create_report report_entries_export }

    it 'returns a workbook' do
      expect(subject).to be_a RubyXL::Workbook
    end

    it 'returns one sheet' do
      expect(subject.worksheets.length).to eq 1
    end

    it 'includes an header with 7 cols' do
      row = subject.worksheets[0][0]
      expect(row[0].value).to eq 'Date'
      expect(row[6].value).to eq 'Notes'
    end

    it 'inserts a date in the first column' do
      create :time_entry, organization: organization, user: report_entries_export.user
      cell = subject.worksheets[0][1][0]
      expect(subject.cell_xfs[cell.style_index].apply_number_format).to eq true
    end
  end

  describe '#perform' do
    subject { described_class.new.perform report_entries_export }

    it 'marks the export as complete' do
      expect { subject }.to change(report_entries_export, :completed?).to true
    end
  end
end
