# frozen_string_literal: true

require 'rails_helper'

feature 'User can create answer', '
  As an authenticated user
  can write the answer to the question
' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'answer the question' do
      fill_in 'Your answer', with: 'text of the answer'

      click_on 'Reply'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content 'text of the answer'
      end
    end

    scenario 'answer the question with errors' do
      click_on 'Reply'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario 'Not authenticated user answer a question' do
    visit question_path(question)

    click_on 'Reply'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
