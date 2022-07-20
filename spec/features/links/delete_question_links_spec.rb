require 'rails_helper'

feature 'User can remove his question links', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be remove my question links
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given!(:link) { create(:link, linkable: question) }

  describe 'Authenticated user', js: true do
    before { sign_in(author) }
    before { visit question_path(question) }

    scenario 'author of the question removes link' do
      within ".link-#{link.id}" do
        click_on 'remove'
      end

      within ".question" do
        expect(page).to_not have_link link.url
      end
    end

    scenario 'not author of the question removes link' do
      click_on 'Log out'
      sign_in(user)
      visit question_path(question)

      within ".link-#{link.id}" do
        expect(page).to_not have_link 'remove'
      end
    end

    scenario 'Not authenticated user delete question link' do
      click_on 'Log out'
      visit question_path(question)

      within ".link-#{link.id}" do
        expect(page).to_not have_link 'remove'
      end
    end
  end
end