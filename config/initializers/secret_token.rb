Cadenza::Application.config.secret_key_base = ENV['APP_SECRET_KEY_BASE']

VkontakteApi.app_id       = ENV["VK_APP_ID"]
VkontakteApi.app_secret   = ENV["VK_APP_SECRET"]
VkontakteApi.redirect_uri = ENV["VK_REDIRECT_URI"]

Echowrap.api_key       = ENV["ECHONEST_API_KEY"]
Echowrap.consumer_key  = ENV["ECHONEST_CONSUMER_KEY"]
Echowrap.shared_secret = ENV["ECHONEST_SHARED_SECRET"]
