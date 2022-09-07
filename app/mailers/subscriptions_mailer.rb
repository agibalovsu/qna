# frozen_string_literal: true

class SubscriptionsMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.subscriptions_mailer.send_notification.subject
  #
  def send_notification(user, answer)
    @answer = answer

    mail to: user.email, subject: 'Answer notification'
  end
end
