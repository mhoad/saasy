# frozen_string_literal: true

require 'stripe'
Stripe.api_key = Rails.application.secrets.stripe[:secret_key]

StripeEvent.configure do |events|
  # events.subscribe 'customer.subcription.', SubscriptionEvent.new
  events.subscribe 'customer.' do |event|
    SubscriptionEvent.process_webhook(event)
  end

  # events.all do |event|
  #   # Handle all event types - logging, etc.
  # end
end

# Ensure that Stripe Webhook URL uses HTTP Basic Auth as per this example:
# https://stripe:my-secret-key@myapplication.com/my-webhook-path
StripeEvent.authentication_secret = Rails.application.secrets.stripe[:webhook_secret]
