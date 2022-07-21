# frozen_string_literal: true

require 'rails_helper'

feature 'User can edit his answer', "
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
" do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  scenario "User tries to edit other user's answers", js: true do
    another_user = create(:user)
    sign_in(another_user)
    visit question_path(question)

    within '.answers' do
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Author tries', js: true do
    background do
      sign_in(user)
      visit question_path(question)
      within '.answers' do
        click_on 'Edit'
      end
    end
    scenario 'edits his answer' do
      within '.answers' do
        fill_in 'Edit answer', with: 'new body'
        click_on 'Save'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'new body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer by adding a link' do
      within '.answers' do
        click_on 'add link'

        fill_in 'Link name', with: 'Thinknetica'
        fill_in 'Url', with: 'http://thinknetica.com'

        click_on 'Save'

        expect(page).to have_link 'Thinknetica', href: 'http://thinknetica.com'
        expect(page).to_not have_selector 'textfield'
      end
    end

    scenario 'edits his answer with errors' do
      within '.answers' do
        fill_in 'Edit answer', with: ''
        click_on 'Save'

        expect(page).to have_content answer.body
        expect(page).to have_selector 'textarea'
      end
      expect(page).to have_content "Body can't be blank"
    end

    scenario 'edits his answer with attach files', js: true do
      within '.answers' do
        fill_in 'Your answer', with: 'edited answer'

        attach_files
        click_on 'Save'

        expect(page).to_not have_selector 'file'
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
