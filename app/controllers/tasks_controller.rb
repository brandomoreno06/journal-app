class TasksController < ApplicationController
  before_action :find_category, only: [:new, :create, :update, :show, :destroy ]
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.where(user_id: current_user.id)
  end

  def show
  end

  def new
    @task = @category.tasks.build
  end

  def new_task
    @category = Category.where(user_id: current_user.id).first
    if @category.nil?
      redirect_to new_category_path
      flash[:alert] = "You need to create a category before creating your first task."
    else
      @task = @category.tasks.build
      redirect_to new_category_task_path(@category)
    end
  end

  def create
    @task = @category.tasks.new(task_params)
    @task.user_id = current_user.id

    if category_owner?
      if @task.save
        redirect_to home_path
        flash[:notice] = "Successfully added a task"
      else
        render :new
      end
    end
  end

  def edit
  end

  def update
    @task.update(task_params)

    if @task.save
      redirect_to home_path
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to home_path
  end

  private
  
  def find_category
    @category = Category.find(params[:category_id])
    category_owner?
  end

  def find_task
    @task = Task.find(params[:id])
    task_owner?
  end

  def task_params
    params.require(:task).permit(:name, :details, :due_date)
  end

  def category_owner?
    unless current_user.id == @category.user_id
      redirect_to home_path
      flash[:alert] = "Unauthorized action"
      return
    end
    return current_user.id == @category.user_id
  end

  def task_owner?
    unless current_user.id == @task.user_id
      redirect_to home_path
      flash[:alert] = "Unauthorized action"
      return
    end
    return current_user.id == @task.user_id
  end
end
