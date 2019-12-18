class Api::V1::ProfilesController < Api::V1::BaseController
  skip_authorization_check

  def me
    render json: current_resource_owner
  end

  def index
    @profiles = User.where.not(id: current_resource_owner.id)
    render json: @profiles, each_serializer: ProfileSerializer
  end
end
