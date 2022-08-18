# frozen_string_literal: true

class OauthRegistrationsController < Devise::RegistrationsController
  def create
    user = User.find_by(email: params['user']['email']) if session['omniauth']

    set_user(user)

    set_session

    yield resource if block_given?
    if resource.persisted?
      active_for_authentication
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end

def set_user(user)
  if user
    resource = user
  else
    resource = build_resource(sign_up_params)
    resource.save
  end
end

def set_session
  if session['omniauth']
    resource.authorizations.create(provider: session['omniauth']['provider'], uid: session['omniauth']['uid'])
    session.delete('omniauth')
  end
end

def active_for_authentication
  if resource.active_for_authentication?
    set_flash_message! :notice, :signed_up
    sign_up(resource_name, resource)
    respond_with resource, location: after_sign_up_path_for(resource)
  else
    set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
    expire_data_after_sign_in!
    respond_with resource, location: after_inactive_sign_up_path_for(resource)
  end
end