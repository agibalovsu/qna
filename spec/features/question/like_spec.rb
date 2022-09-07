# frozen_string_literal: true

require 'rails_helper'

feature 'User can vote for question', "
  In order to encourage best question
  As an authenticated user
  I'd like to be able to vote for question
" do
  given(:user)       { create(:user) }
  given(:author)     { create(:user) }
  given!(:question)  { create(:question, user: author) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'change question rating by voting' do
      within("vote-question-#{question.id}") { click_on 'like +' }

      within("rate-question-#{question.id}") do
        expect(page).to have_content '1'
      end
    end

    scenario 'change question rating by voting' do
      within(".vote-question-#{question.id}") do
        click_on 'like +'
        click_on 'revoke'
      end
      within(".rate-question-#{question.id}") do
        expect(page).to have_content '0'
      end
    end
    scenario 'change question rating by voting' do
      within(".vote-question-#{question.id}") { click_on 'dislike -' }
      within(".rate-question-#{question.id}") do
        expect(page).to have_content '-1'
      end
    end
  end

  describe 'Authenticated author', js: true do
    background do
      sign_in(author)
      visit question_path(question)
    end

    scenario 'cant change question rating by voting' do
      expect(page).to_not have_css ".vote-#{question.id}"
      within(".rate-question-#{question.id}") do
        expect(page).to have_content '0'
      end
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end

    scenario 'cant change question rating by voting' do
      expect(page).to_not have_css ".vote-#{question.id}"
      within(".rate-question-#{question.id}") do
        expect(page).to have_content '0'
      end
    end
  end
end
