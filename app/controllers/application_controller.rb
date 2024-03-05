class ApplicationController < ActionController::Base
  helper_method :current_user
  before_action :authorized
  helper_method :logged_in?

  def current_user
    if session[:user_id]
      begin
        @current_user ||= User.find(session[:user_id])
      rescue ActiveRecord::RecordNotFound
        # Handle the case where the user doesn't exist
        @current_user = nil
        session[:user_id] = nil  # Optionally clear the session
      end
    else
      @current_user = nil
    end
  end

  def logged_in?
    !current_user.nil?
  end

  def authorized
    redirect_to root_path unless logged_in?
  end
end

