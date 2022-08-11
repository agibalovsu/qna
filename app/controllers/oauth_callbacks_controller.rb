class OauthCallbacksController < Devise::OmniauthCallbacksController
	skip_before_action :verify_authenticity_token, only: :github
	
	def github
		@user = User.find_for_oauth(request.env['omniauth.auth'])
		
		if @user&.persisted?
			sign_in_and_redirect @user, event: :authentication
			set_flash_message(:notice, :success, kind: 'GitHub') if is_navigational_format?
		else
      redirect_to root_path
		end
	end
end

