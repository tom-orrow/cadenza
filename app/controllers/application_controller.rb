class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :logged_in?

  def index
    if logged_in?
      render 'authorized'
    else
      render 'unauthorized'
    end
  end

  def logged_in?
    session[:expires_at].present? && !Api::SessionController.expired?(session[:expires_at])
  end
end
