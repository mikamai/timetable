# frozen_string_literal: true

class ProjectsController < ApplicationController
  def index
    @projects = current_user.projects.includes(:organization).load
  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new params.require(:project).permit(:organization_id, :name)
    if @project.save
      redirect_to action: :index
    else
      render :new
    end
  end

  def show
    @organization = current_user.organizations.friendly.find params[:organization_id]
    @project = @organization.projects.friendly.find params[:id]
    @users = @project.users.load
  end

  def edit
    @organization = current_user.organizations.friendly.find params[:organization_id]
    @project = @organization.projects.friendly.find params[:id]
  end

  def update
    @organization = current_user.organizations.friendly.find params[:organization_id]
    @project = @organization.projects.friendly.find params[:id]
    if @project.update params.require(:project).permit(:name)
      redirect_to action: :index
    else
      render :new
    end
  end
end
