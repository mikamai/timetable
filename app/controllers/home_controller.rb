# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :redirect_for_organized_user
  before_action :redirect_for_unorganized_user, only: :index

  def index; end

  private

  def redirect_for_unorganized_user
    return if current_user&.organizations?
    redirect_to new_organization_path, flash: {
      notice: "You don't have any organization. Create one to continue"
    }
  end

  def redirect_for_organized_user
    return if current_user.nil? || current_user.organizations.empty?
    redirect_to last_used_organization
  end

  def last_used_organization
    last_used_organization_in_session || current_user.organizations.by_name.first
  end

  def last_used_organization_in_session
    return unless session[:last_used_organization_id].present?
    current_user.organizations.find session[:last_organization_id]
  rescue ActiveRecord::RecordNotFound
    nil
  end
end
