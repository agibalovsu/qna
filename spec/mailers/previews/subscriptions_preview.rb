# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/subscriptions
class SubscriptionsPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/subscriptions/send_notification
  def send_notification
    SubscriptionsMailer.send_notification
  end
end
