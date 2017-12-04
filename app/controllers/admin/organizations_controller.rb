# frozen_string_literal: true

module Admin
  class OrganizationsController < BaseController
    def index
      @organizations = Organization.order(:name).page(params[:page]).load
      respond_with :admin, @organizations
    end

    def new
      @organization = Organization.new
      respond_with @organization
    end

    def create
      @organization = Organization.new params.require(:organization).permit(:name)
      respond_with :admin, @organization
    end

    def show
      @organization = Organization.friendly.find params[:id]
      @organization_members = @organization.organization_memberships.includes(:user).order('users.email').load
      respond_with :admin, @organization
    end

    def edit
      @organization = Organization.friendly.find params[:id]
      respond_with :admin, @organization
    end

    def update
      @organization = Organization.friendly.find params[:id]
      @organization.update params.require(:organization).permit(:name)
      respond_with :admin, @organization
    end
  end
end
