# frozen_string_literal: true

module Accounts
  class ProjectsController < ApplicationController
    include AccountAuthentication
    before_action :find_project, only: %i[edit update show destroy]

    def index
      @projects = current_account.projects
    end

    def new
      @project = Project.new
    end

    def create
      @project = current_account.projects.build(project_params)
      if @project.save
        flash[:notice] = 'Project was successfully created.'
        redirect_to project_path(@project)
      else
        render 'new'
      end
    end

    def show; end

    def edit; end

    def update
      if @project.update(project_params)
        flash[:notice] = 'Successfully updated project.'
        redirect_to project_path(@project)
      else
        flash[:alert] = 'Error updating project.'
        render :edit
      end
    end

    def destroy
      if @project.destroy
        flash[:notice] = 'Successfully deleted project.'
        redirect_to project_path
      else
        flash[:alert] = 'Error deleting project'
      end
    end

    private

    def project_params
      params.require(:project).permit(:name, :description)
    end

    def find_project
      @project = current_account.projects.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Project not found.'
      redirect_to root_url
    end
  end
end
