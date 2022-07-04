# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete his answer', "
  As an author of answer
  I'd like ot be able to delete my answer
" do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author delete answer', js: true do
    sign_in(author)

    visit question_path(question)

    within '.answers' do
      click_on 'Remove answer'

      expect(page).to_not have_content answer.body
    end
  end

  scenario 'Non author delete answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_content 'Remove answer'
  end

  scenario 'Not authenticated user delete answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end
