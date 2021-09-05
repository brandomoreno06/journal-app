class ApplicationController < ActionController::Base
  include CustomExceptions

  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :route_not_found
  rescue_from UnauthorizedError, with: :unauthorized_error  
  rescue_from NotUniqueCategoryError, with: :not_unique_category_error
  rescue_from NotUniqueEditCategoryError, with: :not_unique_category_error
  
  private
  
  def record_not_found(exception)
    redirect_to root_path, alert: "Unauthorized access"
  end

  def route_not_found(exception)
    redirect_to root_path, alert: "The page you are looking for doesn't exist"
  end

  def after_sign_in_path_for(resource_or_scope)
    home_path
  end

  def unauthorized_error
    redirect_to home_path, error: "Action is restricted."
  end

  def not_unique_category_error
    flash.now[:error] = "A category named \"#{params[:category][:name]}\" already exists."
    if params[:action] == "create"
      render :new
    else
      render :edit
    end
  end
end
