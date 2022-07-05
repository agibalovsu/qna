# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete question', "'
  As an author the question
  can delete the question
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given(:question) { create(:question, user: author) }

  scenario 'Author delete question' do
    sign_in(author)

    visit question_path(question)

    click_on 'Remove question'

    expect(page).to have_content 'Question was successfully deleted'
    expect(page).to_not have_content question.title
    expect(page).to_not have_content question.body
  end

  scenario 'User delete question' do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_content 'Remove question'
  end

  scenario 'Unauthenticated user delete question' do
    visit questions_path

    visit question_path(question)

    expect(page).to_not have_content 'Remove question'
  end
end
