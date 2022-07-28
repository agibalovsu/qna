module Liked
	extend ActiveSupport::Concern

	included do 
		before_action :set_likable, only: %i[like_up like_down revoke]
	end

	def like_up 
		unless current_user.author?(@likable)
			@likable.vote_up(current_user)
			render_json
		end
	end

	def like_down
		unless current_user.author?(@likable)
			@likable.vote_down(current_user)
			render_json
		end
	end

	def revoke
		@likable.likes.find_by(user_id: current_user)&.destroy
		render_json
	end

	private

	def render_json
		render json: { rating: @likable.rating_sum, klass: @likable.class.to_s, id: @likable.id}
	end

	def model_klass
		controller_name.classify.constantize
	end

	def set_likable
		@likable = model_klass.find(params[:id])
	end
end