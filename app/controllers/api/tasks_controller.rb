class Api::TasksController < Api::ApiController

=begin
@api {get} api/me/tasks Read tasks of current user
  @apiName GetTasks
  @apiGroup Tasks
  @apiDescription Read tasks of api's current user

  @apiSuccess (200) {String[]} tasksId Array of tasks slugs, nested in projects
=end

  def me
    hash = {}
    @api_user.projects.each { |p| hash[p.slug] = p.tasks.map(&:slug) }
    render json: { "tasks":  hash }
  end
end