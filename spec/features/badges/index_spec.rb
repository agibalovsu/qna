require 'rails_helper'

feature 'The user can view the rewards he received' do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:badges) { create_list(:badge, 3, question: question) }

  background do
    badges.each do |badge|
      user.get_reward!(badge)
      add_image_to(badge)
    end
  end

  background { sign_in(user) }

  scenario 'have badges list link' do
    expect(page).to have_link 'My badges'
  end

  scenario 'badges list' do
    visit badges_path

    user.badges.each do |badge|
      expect(page).to have_content badge.question.title
      expect(page).to have_css("img[src*='#{badge.image.filename}']")
      expect(page).to have_content badge.title
    end
  end
end