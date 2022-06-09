require 'rails_helper'

feature 'User can sign up', %q{ 
  As an unauthenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistered user tries to sign up' do
    fill_in 'Email', with: 'user@domain.com'
    fill_in 'Password', with: 'userpassword'
    fill_in 'Password confirmation', with: 'userpassword'
    click_on 'Sign up'

    open_email('user@domain.com')
    current_email.click_link 'Confirm my account'
    expect(page).to have_content 'Your email address has been successfully confirmed.'
    expect(current_path).to eq new_user_session_path
  end

  scenario 'Sign up with error(blank fields)' do
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    fill_in 'Password confirmation', with: ''
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
    expect(page).to have_content "Password can't be blank"
  end

  scenario 'Sign up with error(different passwords)' do
    fill_in 'Email', with: 'user@domain.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '87654321'
    click_on 'Sign up'

    expect(page).to have_content "Password confirmation doesn't match Password"
  end

  scenario 'Sign up with error(email is already taken)' do
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password
    click_button 'Sign up'
    expect(page).to have_content 'Email has already been taken'
  end
end