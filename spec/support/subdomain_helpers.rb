# frozen_string_literal: true

module SubdomainHelpers
  def set_subdomain(subdomain)
    site = "#{subdomain}.lvh.me"
    Capybara.app_host = "http://#{site}"
    Capybara.always_include_port = true
    default_url_options[:host] = site.to_s
  end

  def set_default_host
    Capybara.app_host = 'http://lvh.me'
    Capybara.always_include_port = true
    default_url_options[:host] = 'lvh.me'

    return unless Capybara.current_session.server

    port = Capybara.current_session.server.port
    default_url_options[:port] = port
  end
end

RSpec.configure do |c|
  c.include SubdomainHelpers, type: :feature
  c.before type: :feature do
    Capybara.app_host = 'http://lvh.me'
  end
end
