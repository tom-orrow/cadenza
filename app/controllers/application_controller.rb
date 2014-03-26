class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
    @authorized = session[:vk_id].present?
  end
end
