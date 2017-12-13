# frozen_string_literal: true

module Organized
  class OrganizationMembersController < BaseController
    def index
      @organization_members = current_organization.members.by_user_name
    end

    def create
      @organization_member = AddUserToOrganization.perform current_organization, user_email_param
      respond_with current_organization, @organization_member
    end

    def toggle_admin
      @organization_member = current_organization.members.find params[:id]
      @organization_member.update_attribute :admin, !@organization_member.admin
      redirect_to [current_organization, :organization_members]
    end

    private

    def user_email_param
      params[:user]
    end
  end
end
