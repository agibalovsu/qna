# frozen_string_literal: true

require 'rails_helper'

feature 'User can delete answer', '
  As an author of answer to the question
  can delete the answer to the question
' do
  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author delete answer' do
    sign_in(author)
    visit question_path(question)
    click_on 'Remove answer'
    expect(page).to have_content 'Answer successfully deleted.'
  end

  scenario 'User delete answer' do
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_content 'Remove answer'
  end

  scenario 'Unauthenticated user try delete answer' do
    visit question_path(question)

    expect(page).to_not have_content 'Remove answer'
  end
end
