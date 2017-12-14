require 'application_responder'

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.responder = ApplicationResponder
  respond_to :html, :json
  protect_from_forgery with: :exception

  helper_method :current_organization, :available_organizations

  private

  def current_organization
    nil
  end

  def available_organizations
    return [] unless user_signed_in?
    @organizations ||= current_user.organizations.order(:name)
  end
end
