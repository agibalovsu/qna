# frozen_string_literal: true

module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def attach_files
    attach_file 'File', [
      Rails.root.join('spec/rails_helper.rb'),
      Rails.root.join('spec/spec_helper.rb')
    ].map(&:to_s)
  end

  def add_file_to(model)
    model.files.attach(
      io: File.open(Rails.root.join('spec/rails_helper.rb').to_s),
      filename: 'rails_helper.rb'
    )
  end
end
