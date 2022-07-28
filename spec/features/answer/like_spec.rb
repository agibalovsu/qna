require 'rails_helper'

feature 'User can vote for a answer', %q{
  In order to show that answer is good
  As an authenticated user
  I'd like to be able to set 'like' for answer.
} do
  given(:liker) { create(:user) }
  given(:author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given!(:answer) { create(:answer, question: question, user: author) }

  describe 'Authenticated user', js: true do
    before { sign_in(liker) }
    before { visit question_path(question) }

    scenario 'can vote up' do
      within ".answer-#{answer.id}" do
        click_on '+'
        expect(page).to have_content '1'
      end
    end

    scenario 'can vote down' do
      within ".answer-#{answer.id}" do
        click_on '-'
        expect(page).to have_content '-1'
      end
    end

    scenario 'can vote only once' do
      within ".answer-#{answer.id}" do
        click_on '+'
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario "can't vote for self answer" do
      click_on 'Log out'
      sign_in(author)
      visit question_path(question)

      within ".answer-#{answer.id}" do
        expect(page).to_not have_link '+'
        expect(page).to_not have_link '-'
      end
    end

    scenario 'can revote' do
      within ".answer-#{answer.id}" do
        click_on '+'
        expect(page).to have_link 'revoke'

        click_on 'revoke'
        expect(page).to_not have_link 'revoke'
      end
    end
  end
end