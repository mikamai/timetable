class Api::V1::TasksController < Api::V1::ApiController

=begin
@api {get} api/me/tasks Read tasks of current user
  @apiName GetTasks
  @apiGroup Tasks
  @apiDescription Read tasks of api's current user

  @apiSuccess (200) {String[]} tasksId Array of tasks slugs, nested in projects
=end

  def index
    @tasks = scoped_user.tasks.joins(:projects)
      .where(organization_id: params[:organization_id])
      .where(projects: { id: params[:project_id] })
      .distinct
    render json: paginate(@tasks)
  end
end
