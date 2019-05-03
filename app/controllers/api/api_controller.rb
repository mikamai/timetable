# frozen_string_literal: true
class Api::ApiController < ActionController::API
  include Pundit
  before_action :set_api_user
  before_action :set_pundit_user
  skip_before_action :set_pundit_user, only: :me

  rescue_from ActiveRecord::RecordNotFound do |e|
    message = e.model.present? ? I18n.t('activerecord.friendly_id.not_found', resource: e.model) : e
    return_json_error message, :not_found
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    return_json_error e.message.remove("Validation failed: "), 400
  end

  rescue_from Pundit::NotAuthorizedError do
    return_json_error "Forbidden", :forbidden
  end

=begin
@api {get} api/users/me Read user
  @apiName GetUserId
  @apiGroup Users
  @apiDescription Read ID of api user

  @apiSuccess (200) {String} id Id of the user
=end

  def me
    render json: { "id": @api_user.id }
  end

  protected

  def authorization_header
    return nil unless request.headers['Authorization'].present?

    request.headers['Authorization'][/^Bearer (.+)$/, 1]
  end

  def set_api_user
    transaction = AuthenticateUserFromToken.new.call authorization_header: authorization_header
    return return_json_error transaction.failure[:message], transaction.failure[:status] if transaction.failure?

    @api_user = transaction.success
  end

  def set_pundit_user
    @current_user = @api_user.membership_in organization
  end

  def organization
    @organization ||= @api_user.organizations.find(params[:organization_id])
  end

  def user
    @user ||= @current_user.organization.users.find(params[:user_id])
  end

  def week_view
    @week_view ||= WeekView.find_by_time_view_id params[:time_view_id], organization, user
  end

  def time_view
    @time_view ||= week_view.selected_time_view
  end

  def return_json_error error_message, status
    render json: { error: error_message }, status: status
  end
end
