File.open("#{Rails.root}/config/api_keys.yml") do |file|
  config = YAML.load(file.read)
  Cadenza::Application.config.api_accounts = config

  VkontakteApi.app_id       = config["vkontakte"]["app_id"]
  VkontakteApi.app_secret   = config["vkontakte"]["app_secret"]
  VkontakteApi.redirect_uri = 'http://cadenza.me/api/session/callback'

  Echowrap.api_key       = config["echonest"]["api_key"]
  Echowrap.consumer_key  = config["echonest"]["consumer_key"]
  Echowrap.shared_secret = config["echonest"]["shared_secret"]
end
