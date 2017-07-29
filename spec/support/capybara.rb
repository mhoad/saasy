# frozen_string_literal: true

require 'capybara/rails'
require 'capybara/rspec'

Capybara.app_host = "http://#{Rails.configuration.application_settings['domain']}"
