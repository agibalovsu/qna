# frozen_string_literal: true

require 'rails_helper'

describe Ability, type: :model do
  include ControllerHelpers

  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user)           { create :user }
    let(:other)          { create :user }
    let(:question)       { create(:question, user: user) }
    let(:other_question) { create(:question, user: other) }

    before do
      attach_file_to(question)
      attach_file_to(other_question)
    end

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, question }
    it { should_not be_able_to :update, other_question }

    it { should be_able_to :update, create(:answer, question: question, user: user) }
    it { should_not be_able_to :update, create(:answer, question: question, user: other) }

    it { should be_able_to :destroy, question }
    it { should_not be_able_to :destroy, other_question }

    it { should be_able_to :destroy, create(:answer, question: question, user: user) }
    it { should_not be_able_to :destroy, create(:answer, question: question, user: other) }

    it { should be_able_to :destroy, create(:link, linkable: question) }
    it { should_not be_able_to :destroy, create(:link, linkable: other_question) }

    it { should be_able_to :destroy, create(:badge, question: question) }
    it { should_not be_able_to :destroy, create(:badge, question: other_question) }

    it { should be_able_to :destroy, question.files.last }
    it { should_not be_able_to :destroy, other_question.files.last }

    it { should be_able_to :like_up, create(:answer, question: question, user: other) }
    it { should_not be_able_to :like_up, create(:answer, question: question, user: user) }

    it { should be_able_to :like_down, create(:answer, question: question, user: other) }
    it { should_not be_able_to :like_down, create(:answer, question: question, user: user) }

    it { should be_able_to :revoke, create(:answer, question: question, user: other) }
    it { should_not be_able_to :revoke, create(:answer, question: question, user: user) }

    it { should be_able_to :like_up, other_question }
    it { should_not be_able_to :like_up, question }

    it { should be_able_to :like_down, other_question }
    it { should_not be_able_to :like_down, question }

    it { should be_able_to :revoke, other_question }
    it { should_not be_able_to :revoke, question }

    it { should be_able_to :best, create(:answer, question: question, user: other) }
    it { should_not be_able_to :best, create(:answer, question: other_question, user: user) }
    it { should_not be_able_to :best, create(:answer, question: other_question, user: other) }

    it { should be_able_to :create, Subscription }
    it { should be_able_to :destroy, Subscription }
  end
end
