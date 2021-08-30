class CategoriesController < ApplicationController
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @task = @category.tasks
  end

  def new
    @category = Category.new
end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path
    else
      flash.now[:error] = "Failed to add category"
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    @category.update(category_params)

    if @category.save
      redirect_to categories_path
    else
      flash.now[:error] = "Failed to edit category"
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.delete
    
    redirect_to categories_path
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end
end
