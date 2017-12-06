# frozen_string_literal: true

module Organized
  class ProjectMembersController < BaseController
    respond_to :json

    def create
      @project = current_organization.projects.friendly.find params[:project_id]
      @project_member = AddUserToProject.perform @project, user_email_param
      respond_with :admin, @project_member,
                   location: -> { organization_project_path current_organization, @project }
    end

    private

    def user_email_param
      params[:project_member][:user][:email]
    end
  end
end
