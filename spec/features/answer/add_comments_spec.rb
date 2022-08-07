# frozen_string_literal: true

require 'rails_helper'

feature 'Add comment to answer' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'visible a new comment link for answer' do
      within ".answer-#{answer.id}" do
        expect(page).to have_link 'New comment'
      end
    end

    scenario 'add new comment to question' do
      within ".answer-#{answer.id}" do
        click_on 'New comment'
        expect(page).to_not have_link 'New comment'

        fill_in 'Comment', with: 'Test comment'
        click_on 'Add comment'

        expect(page).to have_content 'Test comment'
        expect(page).to have_link 'New comment'
      end
    end
  end

  context 'mulitple sessions', js: true do
    scenario "answers comment appears on another user's page" do
      Capybara.using_session('second_user') do
        second_user = create(:user)

        sign_in(second_user)
        visit question_path(question)
      end

      Capybara.using_session('user') do
        sign_in(user)
        visit question_path(question)

        within ".answer-#{answer.id}" do
          click_on 'New comment'
          fill_in 'Comment', with: 'Test comment'
          click_on 'Add comment'

          expect(page).to have_content 'Test comment'
        end
      end

      Capybara.using_session('second_user') do
        within ".answer-#{answer.id}" do
          expect(page).to have_content 'Test comment'
        end
      end
    end
  end
end
