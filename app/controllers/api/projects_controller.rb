class Api::ProjectsController < Api::ApiController
  skip_before_action :set_pundit_user, only: :index

=begin
@api {get} api/projects Read projects in scope
  @apiName GetProjects
  @apiGroup Projects
  @apiDescription Read projects of api's current user

  @apiSuccess (200) {String[]} projectsId Array of projects slugs, nested in organizations
=end

  def index
    @projects = @api_user.projects.where(filtering_params)
    render json: @projects
  end

  private

  def filtering_params
    params.permit(:organization_id)
  end
end