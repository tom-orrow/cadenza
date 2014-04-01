Cadenza::Application.routes.draw do
  namespace :api do
    resources :session, only: [] do
      collection do
        get :auth
        get :callback
        get ':callback_hack' => 'session#callback', constraints: { :callback_hack => /callback.*/ }
      end
    end
    resources :search, only: [] do
      collection do
        get :complete
        get :search_vk
      end
    end
  end

  root to: "application#index"
end
