require 'rails_helper'

feature 'User can remove his question attachments', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be remove my question attachments
} do

  given(:author) {create(:user)}
  given(:user) {create(:user)}
  given(:question) {create(:question, user: author)}

  describe 'Authenticated user', js: true do
    background do 
      sign_in(author)
      add_file_to(question)
      visit question_path(question)
    end

    scenario 'author of the question removes the attachment' do
      within ".attachment-#{question.files.first.id}" do
        click_on 'remove'
      end

      within ".question" do
        expect(page).to_not have_link 'rails_helper.rb'
      end
    end

    scenario 'not author of the question removes the attachment' do
      click_on 'Log out'
      sign_in(user)
      visit question_path(question)

      within ".attachment-#{question.files.first.id}" do
        expect(page).to_not have_link 'remove'
      end
    end

    scenario 'Not authenticated user delete question attachment' do
      click_on 'Log out'
      visit question_path(question)

      within ".attachment-#{question.files.first.id}" do
        expect(page).to_not have_link 'remove'
      end
    end
  end
end