# frozen_string_literal: true

module Api
  module V1
    class ProfilesController < Api::V1::BaseController
      authorize_resource class: User

      def index
        render json: users_without_authenticated_user, each_serializer: ProfileSerializer
      end

      def me
        render json: current_resource_owner, serializer: ProfileSerializer
      end

      private

      def users_without_authenticated_user
        @users ||= User.where.not(id: doorkeeper_token.resource_owner_id) if doorkeeper_token
      end
    end
  end
end
