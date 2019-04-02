# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ExportReportEntriesJob do
  let(:organization) { create :organization }
  let(:user) { create :user, :organized, organization: organization }
  let(:report_entries_export) { create :report_entries_export, organization: organization, user: user }

  describe '#perform' do
    subject { described_class.new.perform report_entries_export }

    it 'returns the export marked as completed' do
      expect { subject }.to change(report_entries_export, :completed?).to true
    end

    it 'sets the report file in the export object' do
      expect(report_entries_export.file.read).to be_nil
      subject
      expect { RubyXL::Parser.parse_buffer report_entries_export.file.read }.not_to raise_error
    end

    describe 'report' do
      subject do
        described_class.new.perform report_entries_export
        RubyXL::Parser.parse_buffer report_entries_export.file.read
      end

      it 'contains one sheet' do
        expect(subject.worksheets.length).to eq 1
      end

      it 'contains an header with 7 cols' do
        row = subject.worksheets[0][0]
        expect(row[0].value).to eq 'Date'
        expect(row[6].value).to eq 'Notes'
      end

      context 'when there are no entries to show' do
        it 'contains the header only' do
          expect(subject.worksheets[0].sheet_data.rows.length).to eq 1
        end
      end

      context 'when there are some entries to show' do
        before do
          create :time_entry, amount: 90, organization: organization, user: report_entries_export.user
        end

        it 'returns a row per entry' do
          existing_entries_count = rand 4
          existing_entries_count.times do
            create :time_entry, organization: organization, user: report_entries_export.user
          end
          expect(subject.worksheets[0].sheet_data.rows.length).to eq existing_entries_count + 2
        end

        it 'contains a date in the first column' do
          cell = subject.worksheets[0][1][0]
          expect(subject.cell_xfs[cell.style_index].apply_number_format).to eq true
        end

        it 'contains the amount of time in hours' do
          cell = subject.worksheets[0][1][5]
          expect(cell.value).to eq 1.5
        end
      end

      it 'does not include other organization entries' do
        other_membership = create :organization_member, user: report_entries_export.user
        create :time_entry, user: report_entries_export.user, organization: other_membership.organization
        expect(subject.worksheets[0].sheet_data.rows.length).to eq 1
      end

      context 'when the user is not an admin' do
        it 'does not include other user entries' do
          create :time_entry, organization: report_entries_export.organization
          expect(subject.worksheets[0].sheet_data.rows.length).to eq 1
        end
      end

      context 'when the user is an admin' do
        let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

        it 'includes other user entries' do
          create :time_entry, organization: report_entries_export.organization
          expect(subject.worksheets[0].sheet_data.rows.length).to eq 2
        end
      end

      context 'when there are filters applied to the model' do
        let(:report_entries_export) do
          create :report_entries_export,
                 organization: organization,
                 user: user,
                 export_query: { executed_on_lteq: Date.today.strftime('%Y-%m-%d') }
        end

        before do
          u = report_entries_export.user
          o = organization
          create :time_entry, user: u, organization: o, executed_on: 1.day.ago, amount: 60
          create :time_entry, user: u, organization: o, executed_on: 1.day.from_now, amount: 120
        end

        it 'they are applied when creating the report' do
          expect(subject.worksheets[0].sheet_data.rows.length).to eq 2
          expect(subject.worksheets[0][1][5].value).to eq 1.0
        end
      end
    end
  end
end
