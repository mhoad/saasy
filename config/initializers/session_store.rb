# frozen_string_literal: true

options = {
  key: '_sassy_session',
  domain: Rails.configuration.application_settings['domain']
}

Rails.application.config.session_store :cookie_store, options
