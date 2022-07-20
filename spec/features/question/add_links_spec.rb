require 'rails_helper'

feature 'user can add links to question', %q{ 
	In order to provide additional info to my question 
	Add an question's author 
	I'd like to be able add links
} do 

	given(:user) { create(:user) }
	given(:gist_url) { 'https://gist.github.com/agibalovsu/1a4a3b58d7b09b08e94cf827a3ee09a2' }

	scenario 'User adds link when asks question' do 
		sign_in(user)
		visit new_question_path

		fill_in 'Title', with: 'question title'
  	fill_in 'Body', with: 'text of the question'

  	fill_in 'Link name', with: 'My gist'
  	fill_in 'Url', with: gist_url

  	click_on 'Ask'

  	expect(page).to have_link 'My gist', href: gist_url
	end
end