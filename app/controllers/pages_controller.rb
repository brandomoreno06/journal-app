class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]

  def index
    redirect_to root_path and return unless user_signed_in?
    @categories = current_user.categories.order(:created_at)
    @tasks_upcoming = current_user.tasks.where("due_date > ?", Date.current).order(:due_date)
    @tasks_today = Task.where(user_id: current_user.id, due_date: Date.current)
  end

  def landing
    redirect_to home_path if user_signed_in?
  end
end
