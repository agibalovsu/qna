# frozen_string_literal: true

require 'rails_helper'

feature 'User can add comments to question', "
  In order to update or suppliment the information question
  As an authenticated user
  I'd like to be able to add comments
" do
  given(:user)     { create(:user) }
  given(:question) { create(:question, user: user) }

  scenario 'User adds comment to question', js: true do
    sign_in(user)
    visit question_path(question)

    click_on 'New comment'
    fill_in 'comment_body', with: 'My new comment'
    click_on 'Add comment'

    expect(page).to have_content 'My new comment'
  end

  scenario 'Guest tries to add comment to question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Add comment'
  end
end
