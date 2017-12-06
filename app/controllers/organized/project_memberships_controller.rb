# frozen_string_literal: true

module Organized
  class ProjectMembershipsController < BaseController
    respond_to :json

    def create
      @project = current_organization.projects.friendly.find params[:project_id]
      @project_membership = AddUserToProject.perform @project, user_email_param
      respond_with :admin, @project_membership,
                   location: -> { organization_project_path current_organization, @project }
    end

    private

    def user_email_param
      params[:project_membership][:user][:email]
    end
  end
end
