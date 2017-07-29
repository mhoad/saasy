# frozen_string_literal: true

class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @greeting = 'Hi'
    @user = user
    subject = "Welcome to #{Rails.configuration.application_settings['application_name']}"

    mail(to: @user.email, subject: subject)
  end
end
