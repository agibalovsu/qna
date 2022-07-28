require 'rails_helper'

RSpec.shared_examples_for 'likable' do
  let(:model) { described_class }
  let(:author) { create(:user) }
  let(:likers) { create_list(:user, 5) }

  let(:likable) do
    if model.to_s == 'Answer'
      question = create(:question, user: author)
      create(model.to_s.underscore.to_sym, question: question, user: author)
    else
      create(model.to_s.underscore.to_sym, user: author)
    end
  end

  describe '#vote_up' do
    before { likable.vote_up(likers[0]) }

    it 'changed raiting' do
      expect(Like.last.rating).to eq 1
    end

    it 'like user is a @liker' do
      expect(Like.last.user).to eq likers[0]
    end

    it 'like likable is a @likable' do
      expect(Like.last.likable).to eq likable
    end
  end

  describe '#vote_down' do
    before { likable.vote_down(likers[0]) }

    it 'changed raiting' do
      expect(Like.last.rating).to eq -1
    end

    it 'like user is a @liker' do
      expect(Like.last.user).to eq likers[0]
    end

    it 'like likable is a @likable' do
      expect(Like.last.likable).to eq likable
    end
  end

  it '#rating_sum' do
    likable.vote_up(likers[0])
    likable.vote_up(likers[1])
    likable.vote_down(likers[2])
    likable.vote_down(likers[3])
    likable.vote_down(likers[4])

    expect(likable.rating_sum).to eq -1
  end
end