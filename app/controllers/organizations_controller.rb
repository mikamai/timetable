class OrganizationsController < ApplicationController
  before_action :authenticate_user!

  def new
    @organization = Organization.new
    respond_with @organization
  end

  def create
    @organization = Organization.new organization_params
    @organization.members.build user: current_user, admin: true
    @organization.save
    respond_with @organization, location: -> { organization_path(@organization) }
  end

  private

  def organization_params
    params.require(:organization).permit(:name)
  end
end
