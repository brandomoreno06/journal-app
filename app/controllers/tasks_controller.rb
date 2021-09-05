class TasksController < ApplicationController
  before_action :find_category, only: [:new, :create, :update, :show, :destroy ]
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = current_user.tasks
  end

  def show
    @task_category = Category.find_by(id: @task.category_id).name
  end

  def new
    @task = @category.tasks.build
  end

  def new_task
    @category = current_user.categories.first
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

    if @task.save
      redirect_to home_path
      flash[:notice] = "Successfully added a task"
    else
      render :new
    end
  end

  def edit
  end

  def update
    @task.update(task_params)

    if @task.save
      redirect_to home_path
      flash[:notice] = "Successfully updated a task"
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to home_path, alert: "Task named \"#{@task.name}\" has been deleted"
  end


  private

  def task_params
    params.require(:task).permit(:name, :details, :due_date)
  end
  
  def find_category
    @category = Category.find(params[:category_id])
    raise UnauthorizedError unless current_user.id == @category.user_id
  end

  def find_task
    @task = Task.find(params[:id])
    raise UnauthorizedError unless current_user.id == @task.user_id
  end
end
