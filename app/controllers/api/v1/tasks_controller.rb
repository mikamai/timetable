class Api::V1::TasksController < Api::V1::ApiController
  skip_before_action :set_pundit_user, only: :index

=begin
@api {get} api/me/tasks Read tasks of current user
  @apiName GetTasks
  @apiGroup Tasks
  @apiDescription Read tasks of api's current user

  @apiSuccess (200) {String[]} tasksId Array of tasks slugs, nested in projects
=end

  def index
    @tasks = @api_user.tasks
    @tasks = @tasks.where(projects: filtering_params.to_h) unless filtering_params.empty?
    render json: @tasks
  end

  # def by_project
  #   @api_user.projects.find(params[:id])
  # end

  private

  def filtering_params
    params.permit(:organization_id, :id)
  end
end
