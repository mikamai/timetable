# frozen_string_literal: true

module Organized
  class OrganizationMembersController < BaseController
    def index
      @organization_members = current_organization.members.includes(:user).order('users.email')
    end

    def toggle_admin
      @organization_member = current_organization.members.find params[:id]
      @organization_member.update_attribute :admin, !@organization_member.admin
      redirect_to [current_organization, :organization_members]
    end
  end
end
