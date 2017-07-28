# frozen_string_literal: true

# Wrap each test in Bullet API to identify any N+1 queries in testing.
if Bullet.enable?
  config.before(:each) do
    Bullet.start_request
  end

  config.after(:each) do
    Bullet.perform_out_of_channel_notifications if Bullet.notification?
    Bullet.end_request
  end
end
