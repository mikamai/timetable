# frozen_string_literal: true

module Admin
  class OrganizationMembershipsController < BaseController
    respond_to :json

    def create
      @organization = Organization.friendly.find params[:organization_id]
      @organization_membership = AddUserToOrganization.perform @organization, user_email_param
      respond_with :admin, @organization_membership,
                   location: -> { admin_organization_path @organization }
    end

    def toggle_admin
      @organization = Organization.friendly.find params[:organization_id]
      @organization_membership = @organization.organization_memberships.find params[:id]
      @organization_membership.update_attribute :admin, !@organization_membership.admin
      redirect_to admin_organization_path @organization
    end

    private

    def user_email_param
      params[:organization_membership][:user][:email]
    end
  end
end
