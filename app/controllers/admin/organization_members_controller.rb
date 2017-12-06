# frozen_string_literal: true

module Admin
  class OrganizationMembersController < BaseController
    respond_to :json

    def create
      @organization = Organization.friendly.find params[:organization_id]
      @organization_member = AddUserToOrganization.perform @organization, user_email_param
      respond_with :admin, @organization_member,
                   location: -> { admin_organization_path @organization }
    end

    def toggle_admin
      @organization = Organization.friendly.find params[:organization_id]
      @organization_member = @organization.members.find params[:id]
      @organization_member.update_attribute :admin, !@organization_member.admin
      redirect_to admin_organization_path @organization
    end

    private

    def user_email_param
      params[:organization_member][:user][:email]
    end
  end
end
