# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsService do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answer) { create(:answer, question: question, user: user) }
  let!(:subscription) { create(:subscription, question: question, user: user) }

  it 'sends new answer information to subscribed users' do
    question.subscriptions.each do |subscription|
      expect(SubscriptionsMailer).to receive(:send_notification).with(subscription.user, answer).and_call_original
    end
    subject.send_subscriptions(answer)
  end
end
