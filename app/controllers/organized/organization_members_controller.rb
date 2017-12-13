# frozen_string_literal: true

module Organized
  class OrganizationMembersController < BaseController
    def index
      @organization_members = current_organization.members.by_user_name.page params[:page]
    end

    def new
      @organization_member = current_organization.members.build
    end

    def create
      @organization_member = current_organization.members.create create_params
      respond_with current_organization, @organization_member
    end

    def toggle_admin
      @organization_member = current_organization.members.find params[:id]
      @organization_member.update_attribute :admin, !@organization_member.admin
      respond_with current_organization, @organization_member
    end

    def destroy
      @organization_member = current_organization.members.find params[:id]
      @organization_member.destroy
      respond_with current_organization, @organization_member
    end

    private

    def create_params
      params.require(:organization_member).permit :user_email
    end
  end
end
