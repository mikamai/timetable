# frozen_string_literal: true

module Organized
  class RolesController < BaseController
    helper_method :available_users_for_role

    def index
      @roles = current_organization.roles.by_name.page params[:page]
      respond_with current_organization, @roles
    end

    def new
      @role = current_organization.roles.build
      respond_with current_organization, @role
    end

    def create
      @role = current_organization.roles.create client_params
      respond_with current_organization, @role
    end

    def edit
      @role = current_organization.roles.friendly.find params[:id]
      respond_with current_organization, @role
    end

    def update
      @role = current_organization.roles.friendly.find params[:id]
      @role.update_attributes client_params
      respond_with current_organization, @role
    end

    def destroy
      @role = current_organization.roles.friendly.find params[:id]
      @role.destroy
      respond_with current_organization, @role
    end

    private

    def client_params
      params.require(:role).permit :name, user_ids: []
    end

    def available_users_for_role
      current_organization.users.by_name
    end
  end
end
