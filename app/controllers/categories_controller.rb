class CategoriesController < ApplicationController
  before_action :find_category, only: [:show, :edit, :update, :destroy]
  before_action :category_owner?, only: [:show, :edit, :update, :destroy]


  def index
    @categories = Category.where(user_id: current_user.id)
  end

  def show
    @task = @category.tasks
  end

  def new
    @category = Category.new
end

  def create
    @category = Category.new(category_params)
    @category.user_id = current_user.id
    unique_category_per_user #check if name already exists

    if @category.save
      redirect_to home_path
      flash[:notice] = "Successfully created a category."
    else
      render :new
    end
  end

  def edit
  end

  def update
    unique_category_per_user #check if name already exists
      
    if @category.update(category_params)
      redirect_to home_path
      flash[:notice] = "Successfully updated a category."
    else
      render :edit
    end
  end

  def destroy
    @category.destroy  
    redirect_to home_path, alert: "Category named \"#{@category.name}\" has been deleted"
  end


  private

  def category_params
    params.require(:category).permit(:name, :description)
  end

  def find_category
    @category = Category.find(params[:id])
  end

  def category_owner?
    raise UnauthorizedError unless current_user.id == @category.user_id
  end

  def unique_category_per_user
    category = current_user.categories.find_by('lower(name) = ?', params[:category][:name].downcase)

    if params[:action] == "create"
      raise NotUniqueCategoryError if category.present?
    else
      raise NotUniqueEditCategoryError if category.present? && category.id.to_i != params[:id].to_i
    end
  end
end
