module Api
  class SessionController < Api::BaseController
    def auth
      srand
      session[:state] ||= Digest::MD5.hexdigest(rand.to_s)
      redirect_to VkontakteApi.authorization_url(scope: [:audio], state: session[:state])
    end

    def callback
      if session[:state].present? && session[:state] != params[:state]
        redirect_to root_url, alert: 'Ошибка авторизации, попробуйте войти еще раз.' and return
      end

      @vk = VkontakteApi.authorize(code: params[:code])
      session[:token] = @vk.token
      session[:vk_id] = @vk.user_id
      session[:expires_at] = @vk.expires_at

      redirect_to root_url
    end

    def self.expired? (expires_at)
      expires_at && expires_at < Time.now
    end
  end
end
