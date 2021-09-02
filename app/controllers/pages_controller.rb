class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:landing]

  def index
    redirect_to root_path and return unless user_signed_in?
    @categories = Category.where(user_id: current_user.id)
    @tasks_upcoming = Task.where("due_date > ?", Date.current).where(user_id: current_user.id)
    @tasks_today = Task.where(user_id: current_user.id, due_date: Date.current)
  end

  def landing
  end
end
