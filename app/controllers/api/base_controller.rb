module Api
  class BaseController < ::ApplicationController
    respond_to :json

    def validate_request!
      authorize unless session[:expires_at].present? && !Api::SessionController.expired?(session[:expires_at])
      @vk = VkontakteApi::Client.new(session[:token])
    end

    def authorize
      redirect_to auth_api_session_index_path unless session[:token].present?
    end
  end
end
