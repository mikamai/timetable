class Api::V1::ProjectsController < Api::V1::ApiController

=begin
@api {get} api/projects Read projects of current user
  @apiName GetProjects
  @apiGroup Projects
  @apiDescription Read projects of api's current user

  @apiSuccess (200) {String[]} projectsId Array of projects slugs, nested in organizations
=end

  def index
    @projects = scoped_user.organizations.find(params[:organization_id]).projects
    render json: paginate(@projects)
  end

  private

  def filtering_params
    params.permit(:organization_id)
  end
end
