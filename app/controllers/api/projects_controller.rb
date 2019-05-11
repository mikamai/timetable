class Api::ProjectsController < Api::ApiController

=begin
@api {get} api/me/projects Read projects of current user
  @apiName GetProjects
  @apiGroup Projects
  @apiDescription Read projects of api's current user

  @apiSuccess (200) {String[]} projectsId Array of projects slugs, nested in organizations
=end

  def me
    orgs = @api_user.projects.map(&:organization).map(&:slug)
    projects = @api_user.projects.map(&:slug)
    render json: { "projects":  format_hash(orgs, projects) }
  end

  private

  def format_hash orgs, projects
    hash = Hash.new { |h,k| h[k] = [] }
    orgs.each_with_index { |org, i| hash[org.to_sym] << projects[i] }
    hash
  end
end