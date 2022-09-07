# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many(:authorizations).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '#author?' do
    let(:user) { create(:user) }
    let(:any_user) { create(:user) }

    it 'current user is author' do
      question = create(:question, user: user)

      expect(user).to be_author(question)
    end

    it 'current user not an author' do
      question = create(:question, user: any_user)

      expect(user).to_not be_author(question)
    end
  end

  describe '#liked?' do
    let(:user) { create(:user) }
    let(:liker) { create(:user) }
    let(:question) { create(:question, user: user) }

    before { question.vote_up(liker) }

    it 'user already liked question' do
      expect(liker).to be_liked(question)
    end

    it 'user has not liked question' do
      expect(user).to_not be_liked(question)
    end
  end

  describe '.find_for_oauth' do
    let!(:user)   { create(:user) }
    let(:auth)    { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456') }
    let(:service) { double('FindForOauthService') }

    it 'calls FindForOauthService' do
      expect(FindForOauthService).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
    end
  end

  describe '.new_with_session' do
    let!(:session)  { { 'omniauth' => { provider: 'facebook', uid: '123456' } } }
    let(:result)    { User.new_with_session({}, session) }

    it 'creates new user' do
      expect(subject).to be_a_new(User)
    end

    it 'adds password for user' do
      expect(result.password).to_not eq ''
      expect(result.password_confirmation).to_not eq ''
    end
  end

  describe '#subscribed?' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:subscriprion) { create(:subscription, question: question, user: user) }
    let!(:another_user) { create(:user) }

    context 'true if subscribed to question' do
      it { expect(user).to be_subscribed(question) }
    end

    context 'false if if not author of object' do
      it { expect(another_user).to_not be_subscribed(question) }
    end
  end
end
