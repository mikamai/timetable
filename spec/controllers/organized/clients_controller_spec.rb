# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::ClientsController do
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

    context 'when org user accesses' do
      let(:user) { create :user, :organized, organization: organization }

      it 'raises a 404' do
        sign_in user
        expect { call_action }.to raise_error Pundit::NotAuthorizedError
      end
    end
  end

  describe 'GET index' do
    def call_action
      get :index, params: { organization_id: organization.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :index }

      it 'assigns the clients' do
        expect(assigns[:clients]).to be_a ActiveRecord::Relation
        expect(assigns[:clients]).to respond_to :total_pages
      end

      it 'does not include other clients' do
        create :client
        client = create :client, organization: organization
        expect(assigns[:clients].to_a).to eq [client]
      end
    end
  end

  describe 'GET new' do
    def call_action
      get :new, params: { organization_id: organization.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'assigns a newly built client' do
        expect(assigns[:client]).to be_a Client
        expect(assigns[:client]).to be_new_record
      end
    end
  end

  describe 'POST create' do
    def call_action client = { name: 'asd' }
      post :create, params: { organization_id: organization.id, client: client }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }
      before { sign_in user }

      context 'and data is valid' do
        before { call_action }

        it { is_expected.to respond_with :redirect }
        it 'creates a new client' do
          expect(assigns[:client]).to be_persisted
          expect(Client.count).to eq 1
        end
      end
    end
  end

  describe 'GET edit' do
    let(:client) { create :client, organization: organization }

    def call_action
      get :edit, params: { organization_id: organization.id, id: client.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :edit }

      it 'assigns the client' do
        expect(assigns[:client]).to eq client
      end
    end

    context 'prevents access to other organizations' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }
      let(:client) { create :client }

      before { sign_in user }

      it 'raises a 404' do
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'PUT update' do
    let(:client) { create :client, organization: organization }

    def call_action
      put :update, params: { organization_id: organization.id, id: client.id, client: { name: 'asd' } }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to redirect_to organization_clients_path(organization) }

      it 'updates the client' do
        expect { client.reload }.to change(client, :name).to 'asd'
      end
    end

    context 'prevents access to other organizations' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }
      let(:client) { create :client }

      before { sign_in user }

      it 'raises a 404' do
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'DELETE destroy' do
    let(:client) { create :client, organization: organization }

    def call_action
      delete :destroy, params: { organization_id: organization.id, id: client.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to redirect_to organization_clients_path(organization) }

      it 'removes the client' do
        expect { client.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'prevents access to other organizations' do
      let(:user) { create :user, :organized, organization: organization, org_admin: true }
      let(:client) { create :client }

      before { sign_in user }

      it 'raises a 404' do
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
