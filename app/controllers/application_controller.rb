class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :logged_in?

  def index
  end

  def logged_in?
    session[:token].present?
  end
end
