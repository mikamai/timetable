class Api::TimeEntriesController < Api::ApiController
  before_action :set_time_view, only: [:index, :index_project, :create]

  def index
    raise_if_unauthorized
    @time_entries = time_view.time_entries
    render json: @time_entries
  end

  def index_project
    raise_if_unauthorized
    @time_entries = time_view.time_entries.where(project_id: new_or_current_project.id)
    render json: @time_entries
  end

  def create
    @time_entry = TimeEntry.new create_params
    authorize @time_entry
    @time_entry.save!

    render json: @time_entry
  end

  def update
    authorize time_entry
    time_entry.update_attributes! update_params
    render json: time_entry
  end

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
    params.permit(:notes, :time_amount, :task_id)
          .merge(executed_on: @time_view.date, user_id: user.id, project_id: new_or_current_project.id)
  end

  def update_params
    params.permit(:notes, :time_amount, :executed_on, :task_id)
          .merge(project_id: new_or_current_project.id)
  end

  def new_or_current_project
    @new_or_current_project ||= params[:project_id] ? organization.projects.find(params[:project_id]) : time_entry.project
  end

  def set_time_view
    @time_view ||= TimeView.find params[:time_view_id], @organization, user
  end

  def time_entry
    @time_entry ||= user.time_entries.find(params[:id])
  end
end