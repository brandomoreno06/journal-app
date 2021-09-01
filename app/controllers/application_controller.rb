class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActionController::RoutingError, with: :route_not_found

  
  private
  
  def record_not_found(exception)
    redirect_to root_path, notice: "Unauthorized access"
  end

  def route_not_found(exception)
    redirect_to root_path, notice: "The page you are looking for doesn't exist"
  end

  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
end
