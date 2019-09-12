# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::ReportEntriesExportsController do
  let(:organization) { create :organization }

  shared_examples 'authentication' do
    context 'when user is not logged in' do
      before { call_action }

      it { is_expected.to redirect_to new_user_session_path }
    end

    context 'when user has no access to the current organization' do
      let(:user) { create :user, admin: true }

      it 'raises a 404' do
        sign_in user
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'POST create' do
    def call_action export_query = 'null'
      post :create, params: {
        organization_id:       organization.id,
        report_entries_export: { export_query: export_query }
      }
    end

    include_examples 'authentication'

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      before { sign_in user }

      it 'assigns a newly created ReportEntriesExport' do
        call_action
        expect(assigns[:export]).to be_a ReportEntriesExport
        expect(assigns[:export]).to be_persisted
      end

      it 'raises an error if the export_query param is not a json' do
        expect {
          call_action 'asd'
        }.to raise_error BadJsonProvidedError
      end

      it 'sets the export_query param into the model' do
        project = create :project, organization: organization
        data = { project_id_in: [project.id] }
        call_action data.to_json
        expect(assigns[:export].export_query).to eq "project_id_in" => [project.id.to_s]
      end

      it 'enqueues the actual export' do
        expect { call_action }.to have_enqueued_job(ExportReportEntriesJob)
      end

      it 'redirects to the show page' do
        call_action
        expect(response).to redirect_to organization_report_entries_export_path organization, assigns[:export]
      end
    end
  end

  describe 'GET show' do
    let(:report_user) { create :user, :organized, organization: organization }
    let(:report_entries_export) { create :report_entries_export, organization: organization, user: report_user }

    def call_action
      get :show, params: { organization_id: organization.id, id: report_entries_export.id }
    end

    include_examples 'authentication'

    describe 'when org admin accesses another user report' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
    end

    describe 'when org user accesses another user report' do
      let(:user) { create :user, :organized, organization: organization }

      it 'access is forbidden' do
        sign_in user
        expect { call_action }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end
end
