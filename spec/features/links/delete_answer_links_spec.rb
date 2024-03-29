# frozen_string_literal: true

require 'rails_helper'

feature 'User can remove his answer links', "
  In order to correct mistakes
  As an author of answer
  I'd like be remove my answer links
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }
  given(:answer) { create(:answer, question: question, user: author) }
  given!(:link) { create(:link, linkable: answer) }

  describe 'Authenticated user', js: true do
    scenario 'author of the answer removes link' do
      sign_in(author)
      visit question_path(question)

      within ".link-#{link.id}" do
        click_on 'remove'
      end

      within '.question' do
        expect(page).to_not have_link link.url
      end
    end

    scenario 'not author of the answer removes link' do
      sign_in(user)
      visit question_path(question)

      within ".link-#{link.id}" do
        expect(page).to_not have_link 'remove'
      end
    end
  end

  scenario 'Not authenticated user delete answer link', js: true do
    visit question_path(question)

    within ".link-#{link.id}" do
      expect(page).to_not have_link 'remove'
    end
  end
end
