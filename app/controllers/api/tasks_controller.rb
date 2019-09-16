class Api::TasksController < Api::ApiController
  skip_before_action :set_pundit_user, only: :index

=begin
@api {get} api/me/tasks Read tasks of current user
  @apiName GetTasks
  @apiGroup Tasks
  @apiDescription Read tasks of api's current user

  @apiSuccess (200) {String[]} tasksId Array of tasks slugs, nested in projects
=end

  def index
    @tasks = @api_user.projects.where(filtering_params).map(&:tasks).flatten
    render json: @tasks
  end

  private

  def filtering_params
    params.permit(:organization_id, :id)
  end
end
