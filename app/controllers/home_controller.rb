# frozen_string_literal: true

class HomeController < ApplicationController
  before_action :authenticate_user!, only: :no_organization
  before_action :redirect_for_organized_user
  before_action :redirect_for_unorganized_user, only: :index

  def index; end

  def no_organization; end

  private

  def redirect_for_unorganized_user
    return unless current_user
    redirect_to no_organization_path if current_user.organizations.empty?
  end

  def redirect_for_organized_user
    return if current_user.nil? || current_user.organizations.empty?
    redirect_to organized_root_path last_used_organization
  end

  def last_used_organization
    last_used_organization_in_session || current_user.organizations.order('name').first
  end

  def last_used_organization_in_session
    return unless session[:last_organization_id].present?
    current_user.organizations.find session[:last_organization_id]
  end
end
