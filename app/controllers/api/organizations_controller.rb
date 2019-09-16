class Api::OrganizationsController < Api::ApiController
  skip_before_action :set_pundit_user, only: :index

=begin
@api {get} api/me/orgs Read organizations of current user
  @apiName GetOrganizations
  @apiGroup Organizations
  @apiDescription Read organizations of api's current user

  @apiSuccess (200) {String[]} OrganizationsId Array of organizations slugs
=end

  def index
    @organizations = @api_user.organizations
    render json: @organizations
  end
end
