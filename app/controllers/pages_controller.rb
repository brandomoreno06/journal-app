class PagesController < ApplicationController
  def index
    @categories = Category.where(user_id: current_user.id)
    @tasks = Task.where(user_id: current_user.id)
    @tasks_today = Task.where(user_id: current_user.id, due_date: Date.current)
  end
end
