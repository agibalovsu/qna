# frozen_string_literal: true

require 'rails_helper'

feature 'User can view list of questions', "
  In order to view list of questions
  As an unauthenticated user
  I'd like to be able to view list of questions
" do
  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3, user: user) }

  scenario 'Unauthenticated user can view questions' do
    visit questions_path

    questions.each { |question| expect(page).to have_content question.title }
  end
end
