class TasksController < ApplicationController
  before_action :find_category, only: [:new, :create, :update, :show, :destroy ]
  before_action :find_task, only: [:show, :edit, :update, :destroy]

  def index
    @tasks = Task.all
  end

  def show
  end

  def new
    @task = @category.tasks.build
  end

  def create
    @task = @category.tasks.create(task_params)

    if @task.save
      redirect_to category_path(@category)
    else
      render :new
    end
  end

  def edit
  end

  def update
    @task.update(task_params)

    if @task.save
      redirect_to category_path(@category)
    else
      render :edit
    end
  end

  def destroy
    @task.destroy
    redirect_to category_path(@category)
  end

  private
  
  def find_category
    @category = Category.find(params[:category_id])
  end

  def find_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:name, :details, :due_date)
  end
end
