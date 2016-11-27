Rails.application.config.middleware.use OmniAuth::Builder do
  require "#{Rails.root}/lib/omni_auth/strategies/party_registry"
  require "#{Rails.root}/lib/oauth2/error"
  provider :party_registry
end
