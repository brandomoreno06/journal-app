class CategoriesController < ApplicationController

  def index
    @categories = Category.where(user_id: current_user.id)
  end

  def show
    @category = Category.find(params[:id])
    category_owner?
    @task = @category.tasks
  end

  def new
    @category = Category.new
end

  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id

    if @category.save
      redirect_to categories_path
    else
      flash.now[:error] = "Failed to add category"
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
    category_owner?
  end

  def update
    @category = Category.find(params[:id])
    if category_owner?
      @category.update(category_params)
        
      if @category.save
        redirect_to categories_path
      else
        flash.now[:error] = "Failed to edit category"
        render :edit
      end
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if category_owner?
      @category.destroy  
      redirect_to categories_path
    end
  end

  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def category_owner?
    unless current_user.id == @category.user_id
      redirect_to root_path
      flash[:alert] = "Unauthorized action"
      return
    end
    return current_user.id == @category.user_id
  end
end
