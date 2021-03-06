# frozen_string_literal: true

module Organized
  class OrganizationMembersController < BaseController
    def index
      @organization_members = current_organization.members.by_user_name.page params[:page]
      authorize current_organization.members.build
    end

    def new
      @organization_member = current_organization.members.build
      authorize @organization_member
    end

    def create
      @organization_member = current_organization.members.build create_params
      authorize @organization_member
      @organization_member.save
      respond_with current_organization, @organization_member
    end

    def resend_invitation
      @organization_member = current_organization.members.find params[:id]
      authorize @organization_member
      @organization_member.user.deliver_invitation
      respond_with current_organization, @organization_member
    end

    def update_role
      @organization_member = current_organization.members.find params[:id]
      authorize @organization_member
      @organization_member.update_attributes role: params[:role]
      respond_with current_organization, @organization_member
    end

    def destroy
      @organization_member = current_organization.members.find params[:id]
      authorize @organization_member
      @organization_member.destroy
      respond_with current_organization, @organization_member
    end

    private

    def create_params
      params.require(:organization_member).permit :user_email
    end
  end
end
