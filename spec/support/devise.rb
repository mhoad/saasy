# frozen_string_literal: true

RSpec.configure do |config|
  config.include Devise::Test::ControllerHelpers, type: :controller
  config.include Warden::Test::Helpers
  # config.include RequestSpecHelper, type: :request

  config.after :each do
    Warden.test_reset!
  end
end
