# frozen_string_literal: true

module Organized
  class OrganizationMembershipsController < BaseController
    def index
      @organization_memberships = current_organization.organization_memberships.includes(:user).order('users.email')
    end

    def toggle_admin
      @organization_membership = current_organization.organization_memberships.find params[:id]
      @organization_membership.update_attribute :admin, !@organization_membership.admin
      redirect_to [current_organization, :organization_memberships]
    end
  end
end
