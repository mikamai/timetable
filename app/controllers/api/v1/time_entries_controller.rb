class Api::V1::TimeEntriesController < Api::V1::ApiController
  before_action :set_time_view, only: [:index, :index_project, :create]

=begin
@api {get} /orgs/:organizationId/users/:userId/time/:timeViewId/entries Index Time Entries.
 @apiName GetTimeEntries
 @apiGroup TimeEntries
 @apiDescription Read Time Entries for User on Day

 @apiParam {String} organizationId Organization's unique slug or ID
 @apiParam {String} userId User's unique ID (accepts also "me")
 @apiParam {String} timeViewId TimeView's unique slug or ID

 @apiSuccess (200) {Object[]} timeEntries Array of Time Entries regirstered on TimeView day, all projects included.
=end

  def index
    raise_if_unauthorized
    @time_entries = time_view.time_entries
    render json: @time_entries
  end

=begin
@api {get} /orgs/:organizationId/users/:userId/time/:timeViewId/projects/:projectId/entries IndexProject Time Entries.
 @apiName GetTimeEntriesForProject
 @apiGroup TimeEntries
 @apiDescription Read Time Entries for User on Project on Day

 @apiParam {String} organizationId Organization's unique Slug or ID
 @apiParam {String} userId User's unique ID (accepts also "me")
 @apiParam {String} timeViewId TimeView's unique slug or ID
 @apiParam {String} projectId Project's unique Slug or slug or ID

 @apiSuccess (200) {Object[]} timeEntries Array of Time Entries registered on TimeView day on the project.
=end

  def index_project
    raise_if_unauthorized
    @time_entries = time_view.time_entries.where(project_id: new_or_current_project.id)
    render json: @time_entries
  end

=begin
@api {post} /orgs/:organizationId/users/:userId/time/:timeViewId/projects/:projectId/entries Create Time Entry.
 @apiName CreateTimeEntry
 @apiGroup TimeEntries
 @apiDescription Create Time Entry for User on Project on Day

 @apiParam {String} organizationId Organization's unique Slug
 @apiParam {String} userId User's unique ID (accepts also "me")
 @apiParam {String} timeViewId TimeView's unique ID
 @apiParam {String} projectId Project's unique Slug or ID
 @apiParam {String} [taskId] Task's unique Slug or ID
 @apiParam {Number} [timeAmount] Number of hours
 @apiParam {String} [notes] TimeEntry's Notes

 @apiSuccess (200) {Object} timeEntry TimeEntry Created
=end

  def create
    @time_entry = TimeEntry.new create_params
    authorize @time_entry
    @time_entry.save!
    render json: @time_entry
  end

=begin
@api {put} /orgs/:organizationId/users/:userId/entries/:timeEntryId Update time_entry
 @apiName UpdateTimeEntry
 @apiGroup TimeEntries
 @apiDescription Update Time Entry

 @apiParam {String} organizationId Organization's unique Slug
 @apiParam {String} userId User's unique ID (accepts also "me")
 @apiParam {String} timeEntryId TimeEntry's unique ID
 @apiParam {String} [timeViewId] TimeView's unique ID
 @apiParam {String} [projectId] Project's unique Slug or ID
 @apiParam {String} [taskId] Task's unique Slug or ID
 @apiParam {Number} [timeAmount] Number of hours
 @apiParam {String} [notes] TimeEntry's Notes

@apiSuccess (200) {Object} timeEntry TimeEntry Updated
=end

  def update
    authorize time_entry
    time_entry.update_attributes! update_params
    render json: time_entry
  end

=begin
@api {delete} /orgs/:organizationId/users/:userId/entries/:timeEntryId Delete time_entry
 @apiName DeleteTimeEntry
 @apiGroup TimeEntries
 @apiDescription Delet Time Entry

 @apiParam {String} organizationId Organization's unique Slug or ID
 @apiParam {String} userId User's unique ID (accepts also "me")
 @apiParam {String} timeEntryId TimeEntry's unique ID

 @apiSuccess (202)
=end

  def destroy
    authorize time_entry
    time_entry.destroy
    render json: {}, status: 202
  end

  private

  def raise_if_unauthorized
    raise Pundit::NotAuthorizedError unless Organized::TimeViewPolicy.new(@current_user, time_view).show?
  end

  def create_params
    params.permit(:notes, :time_amount)
          .merge(executed_on: @time_view.date, user_id: scoped_user.id, project_id: new_or_current_project.id, task: task)
  end

  def update_params
    params.permit(:notes, :time_amount, :executed_on)
          .merge(project_id: new_or_current_project.id, task: task)
  end

  def new_or_current_project
    @new_or_current_project ||= params[:project_id] ? organization.projects.find(params[:project_id]) : time_entry.project
  end

  def task
    @task ||= @new_or_current_project.tasks.find(params[:task_id])
  end

  def set_time_view
    @time_view ||= TimeView.find params[:time_view_id], @organization, scoped_user
  end

  def time_entry
    @time_entry ||= scoped_user.time_entries.find(params[:id])
  end
end
