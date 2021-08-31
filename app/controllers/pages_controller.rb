class PagesController < ApplicationController
  def index
    @categories = Category.where(user_id: current_user.id)
    @tasks = Task.all
    @tasks_today = Task.where(due_date: Date.current)
  end
end
