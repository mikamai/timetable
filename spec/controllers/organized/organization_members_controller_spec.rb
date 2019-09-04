# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Organized::OrganizationMembersController do
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
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :index }

      it 'assigns the clients' do
        expect(assigns[:organization_members]).to be_a ActiveRecord::Relation
        expect(assigns[:organization_members]).to respond_to :total_pages
      end

      it 'does not include members of other organizations' do
        create :organization_member
        expect(assigns[:organization_members].to_a).to eq user.organization_memberships
      end
    end
  end

  describe 'GET new' do
    def call_action
      get :new, params: { organization_id: organization.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to respond_with :ok }
      it { is_expected.to render_template :new }

      it 'assigns a newly built client' do
        expect(assigns[:organization_member]).to be_a OrganizationMember
        expect(assigns[:organization_member]).to be_new_record
      end
    end
  end

  describe 'POST create' do
    let(:organization_member_params) { { user_email: 'foo@mail.com' } }

    def call_action
      post :create, params: { organization_id: organization.id, organization_member: organization_member_params }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before do
        sign_in user
        call_action
      end

      context 'and data is valid' do
        it { is_expected.to respond_with :redirect }

        it 'creates a new organization member' do
          expect(assigns[:organization_member]).to be_a OrganizationMember
          expect(assigns[:organization_member]).to be_persisted
          expect(organization.members.count).to eq 2
        end

        it 'invites an user if this does not exist' do
          expect(User.where.not(invitation_sent_at: nil)).to be_any
        end
      end

      context 'and client is invalid' do
        let(:organization_member_params) { { name: '' } }

        it { is_expected.to render_template 'new' }
      end
    end
  end

  describe 'DELETE destroy' do
    let(:organization_member) { create :organization_member, organization: organization }

    def call_action
      delete :destroy, params: { organization_id: organization.id, id: organization_member.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before do
        sign_in user
        call_action
      end

      it { is_expected.to redirect_to organization_organization_members_path(organization) }

      it 'removes the organization member' do
        expect { organization_member.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'prevents access to other organizations' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }
      let(:organization_member) { create :organization_member }

      before { sign_in user }

      it 'raises a 404' do
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'PATCH update role' do
    let(:organization_member) { create :organization_member, organization: organization }

    def call_action role = 'user'
      patch :update_role, params: { organization_id: organization.id, id: organization_member.id, role: role }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before do
        sign_in user
      end

      context 'for a plain organization member' do
        it 'grants admin privileges' do
          call_action 'admin'
          expect { organization_member.reload }.to change(organization_member, :role).to 'admin'
        end
      end

      context 'for an admin organization member' do
        let(:organization_member) { create :organization_member, organization: organization, role: 'admin' }

        it 'removes admin privileges' do
          call_action 'super_user'
          expect { organization_member.reload }.to change(organization_member, :role).to 'super_user'
        end
      end
    end

    context 'prevents access to other organizations' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }
      let(:organization_member) { create :organization_member }

      before { sign_in user }

      it 'raises a 404' do
        expect { call_action 'user' }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe 'PATCH resend_invitation' do
    let(:invited_user) { create :user, :invited }
    let(:organization_member) { create :organization_member, user: invited_user, organization: organization }

    def call_action
      patch :resend_invitation, params: { organization_id: organization.id, id: organization_member.id }
    end

    include_examples 'authentication'

    context 'when org admin accesses' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }

      before do
        sign_in user
        organization_member
        call_action
      end

      it { is_expected.to redirect_to organization_organization_members_path(organization) }

      it 'sends a new invitation to the user' do
        # one is sent at the user creation
        expect(ActiveJob::Base.queue_adapter.enqueued_jobs.length).to eq 2
      end
    end

    context 'prevents access to other organizations' do
      let(:user) { create :user, :organized, organization: organization, org_role: 'admin' }
      let(:organization_member) { create :organization_member }

      before { sign_in user }

      it 'raises a 404' do
        expect { call_action }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
