# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his question', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be edit my question
" do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'Unauthenticated can not edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit question'
  end

  scenario "tries to edit other user's question", js: true do
    another_user = create(:user)
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_selector 'file'
    expect(page).to_not have_link 'Edit question'
  end

  describe 'Author tries', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      click_on 'Edit question'
    end

    scenario 'edits his question' do
      within '.question' do
        fill_in 'Edit title', with: 'Question title'
        fill_in 'Edit body', with: 'Question body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to_not have_content question.title
        expect(page).to have_content 'Question title'
        expect(page).to have_content 'Question body'
        expect(page).to_not have_selector 'textfield'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his question with attach files' do
      within '.question' do
        fill_in 'Edit title', with: 'Question title'
        fill_in 'Edit body', with: 'Question body'

        attach_files
        click_on 'Save'

        expect(page).to_not have_selector 'file'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end

    scenario 'edits his question with errors' do
      within '.question' do
        fill_in 'Edit title', with: ' '
        fill_in 'Edit body', with: ' '
        click_on 'Save'

        expect(page).to have_content question.body
        expect(page).to have_content question.title
        expect(page).to have_selector 'input'
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
      expect(page).to have_content "Title can't be blank"
    end
  end
end
