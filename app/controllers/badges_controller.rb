# frozen_string_literal: true

class BadgesController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize! :index, Badge
    @badges = current_user&.badges
  end
end
