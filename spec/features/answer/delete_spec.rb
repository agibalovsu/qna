require 'rails_helper'

feature 'User can delete answer', %q{ 
  As an author of answer to the question
  can delete the answer to the question
} do

  given(:author) { create(:user) }
  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: author) }

  scenario 'Author delete answer' do 
    sign_in(author)

    visit question_path(question)

    within '.answers' do
      click_on 'Remove answer'

      expect(page).to_not have_content answer.body
    end

    expect(page).to have_content 'Answer was successfully deleted'
  end 

  scenario 'User delete answer' do 
    sign_in(user)

    visit question_path(question)

    expect(page).to_not have_content 'Remove answer'  
  end 
 
  scenarion 'Unauthenticated user try delete answer' do 
    visit question_path(question)

    expect(page).to_not have_content 'Delete answer'
  end
end