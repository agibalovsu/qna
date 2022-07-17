# frozen_string_literal: true

require 'rails_helper'

feature 'Best answer', '
  to cheese the answer which is the best
  As an authenticated user
  I want to be able to set best answer to my question
' do
  given!(:user) { create(:user) }
  given!(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:first_answer) { create(:answer, question: question, user: user) }
  given!(:second_answer) { create(:answer, question: question, user: user) }
  given!(:third_answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user or non question author can not set best answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Choose the best'
  end

  describe 'Authenticated user is question author', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'best answer link not available for best answer' do
      within(".answer-#{first_answer.id}") do
        click_on 'Choose the best'

        expect(page).to_not have_link 'Choose the best'
      end

      within(".answer-#{second_answer.id}") do
        expect(page).to have_link 'Choose the best'
      end
    end

    scenario 'best answer is first in list' do
      expect(third_answer).to_not eq question.answers.first

      within(".answer-#{third_answer.id}") do
        click_on 'Choose the best'

        wait_for_ajax
      end

      third_answer.reload

      expect(third_answer).to eq question.answers.first
    end
  end
end
