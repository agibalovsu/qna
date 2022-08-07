# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comments to question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'visible a new comment link' do
      expect(page).to have_link 'New comment'
    end

    scenario 'add new comment to question' do
      click_on 'New comment'
      expect(page).to_not have_link 'New comment'

      fill_in 'Comment', with: 'Test comment'
      click_on 'Add comment'

      expect(page).to have_content 'Test comment'
      expect(page).to have_link 'New comment'
    end
  end

  context 'mulitple sessions', js: true do
    scenario "question appears on another user's page" do
      Capybara.using_session('second_user') do
        second_user = create(:user)

        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        click_on 'New comment'
        fill_in 'Comment', with: 'Test comment'
        click_on 'Add comment'

        expect(page).to have_content 'Test comment'
      end

      Capybara.using_session('second_user') do
        expect(page).to have_content 'Test comment'
      end
    end
  end
end
