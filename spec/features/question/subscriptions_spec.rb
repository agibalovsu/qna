# frozen_string_literal: true

require 'rails_helper'

feature 'User can subscribe/unsubscribe for question', "
  In order to follow/stop follow the answers for question
  As an authenticated user
  I'd like to be able to subscribe/unsubscribe to question
" do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario 'subscribe/unsubscribe to question' do
      click_on 'Subscribe'
      expect(page).to have_link 'Unsubscribe'

      click_on 'Unsubscribe'
      expect(page).to have_link 'Subscribe'
    end
  end

  describe 'Unauthenticated user', js: true do
    background do
      visit question_path(question)
    end

    scenario 'cant change question rating by voting' do
      expect(page).to_not have_css '.subscription'
      expect(page).to_not have_link 'Subscribe'
    end
  end
end
