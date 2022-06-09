require 'rails_helper'

ffeature 'User can view list of answers to the question on question page', %q{ 
  In order to view list of answers on question page 
  As an unauthenticated user
  I'd like to be able to view list of answers
} do 
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 3, question: question, user: user) }

  scenario 'answers list on the question page' do
    visit question_path(question)

    expect(page).to have_content question.title
    expect(page).to have_content question.body
    answers.each { |answer| expect(page).to have_content answer.body }
  end
end