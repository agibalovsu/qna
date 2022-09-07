# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SubscriptionsMailer, type: :mailer do
  describe 'send_notification' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { SubscriptionsMailer.send_notification(user, answer) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Answer notification')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to have_content('New answer to subscribed questions')
    end
  end
end
