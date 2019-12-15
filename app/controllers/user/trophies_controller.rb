class User::TrophiesController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def index
    @trophies = current_user.trophies
  end
end
