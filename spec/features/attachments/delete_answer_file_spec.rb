# frozen_string_literal: true

require 'rails_helper'

feature 'User can remove his answer attachments', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be remove my answer attachments
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(author)
      add_file_to(answer)
      visit question_path(question)
      fill_in 'Your answer', with: 'answer body'

      attach_files
      click_on 'Reply'
    end

    scenario 'author of the answer removes the attachment' do
      within ".attachment-#{answer.files.first.id}" do
        click_on 'remove'
      end

      within ".answer-#{answer.id}" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'not author of the answer removes the attachment' do
      click_on 'Log out'
      sign_in(user)
      visit question_path(question)

      within ".attachment-#{answer.files.first.id}" do
        expect(page).to_not have_link 'remove'
      end
    end

    scenario 'Not authenticated user delete question attachment' do
      click_on 'Log out'
      visit question_path(question)

      within ".attachment-#{answer.files.first.id}" do
        expect(page).to_not have_link 'remove'
      end
    end
  end
end
