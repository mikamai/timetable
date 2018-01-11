require 'application_responder'

# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit
  respond_to :html, :json
  protect_from_forgery with: :exception

  before_action :verify_requested_format!
  before_action :configure_permitted_parameters, if: :devise_controller?

  helper_method :current_organization, :available_organizations

  self.responder = ApplicationResponder

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: %i[first_name last_name phone])
  end

  private

  def current_organization
    nil
  end

  def available_organizations
    return [] unless user_signed_in?
    @organizations ||= current_user.organizations.order(:name)
  end

  def disable_caching
    response.headers['Cache-Control'] = 'no-cache, no-store'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end
end
