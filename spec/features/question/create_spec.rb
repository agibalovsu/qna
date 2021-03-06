# frozen_string_literal: true

require 'rails_helper'

feature 'User can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
" do
  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path

      click_on 'New question'
    end

    scenario 'asks a question' do
      fill_in 'Title', with: 'question title'
      fill_in 'Body', with: 'text of the question'
      click_on 'Ask'

      expect(page).to have_content 'Your Question was successfully created'
      expect(page).to have_content 'question title'
      expect(page).to have_content 'text of the question'
    end

    scenario 'asks a question with errors' do
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank"
    end

    scenario 'asks a question with attached file' do
      fill_in 'Title', with: 'question title'
      fill_in 'Body', with: 'text of the question'

      attach_files
      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end

    scenario 'ask question with badge' do
      fill_in 'Title', with: 'Question title'
      fill_in 'Body', with: 'Question body'

      fill_in 'Badge title', with: 'Very best answer'
      attach_file 'Image', Rails.root.join('app/assets/images/badges/default.png').to_s

      click_on 'Ask'

      expect(page).to have_content 'Very best answer'
      expect(page).to have_css("img[src*='default.png']")
    end
  end

  scenario 'Unauthenticated user tries to ask a question' do
    visit questions_path
    click_on 'New question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
