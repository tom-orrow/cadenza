module Api
  class BaseController < ::ApplicationController
    respond_to :json
    before_filter :validate_request!

    def validate_request!
      redirect_to auth_api_session_index_path unless session[:token].present?
      @vk = VkontakteApi::Client.new(session[:token])
    end
  end
end
