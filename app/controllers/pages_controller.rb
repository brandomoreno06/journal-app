class PagesController < ApplicationController
  def index
    @categories = Category.all
    @tasks = Task.all
    @tasks_today = Task.where(due_date: Date.current)
  end
end
