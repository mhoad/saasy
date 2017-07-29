# frozen_string_literal: true

Sidekiq.configure_server do |config|
  config.redis = { url: Rails.configuration.application_settings['redis']['server']['url'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: Rails.configuration.application_settings['redis']['client']['url'] }
end
