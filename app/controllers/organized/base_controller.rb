# frozen_string_literal: true

module Organized
  class BaseController < ApplicationController
    layout 'organized'
    respond_to :html, :json

    before_action :authenticate_user!
    before_action :set_current_organization

    helper_method :current_organization, :available_organizations

    def current_organization
      @organization
    end

    private

    def organization_param
      params[:organization_id]
    end

    def set_current_organization
      @organization = current_user.organizations.friendly.find organization_param
      session[:last_organization_id] = @organization.id
    end

    def available_organizations
      @organizations ||= current_user.organizations.order(:name)
    end
  end
end
