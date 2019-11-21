module Voted
  extend ActiveSupport::Concern

  included do
    before_action :resource, only: %i[vote_up vote_down]
  end

  def vote_up
    return head 403 if current_user&.author_of?(@resource)

    @resource.upvote!(current_user)
    render_json(@resource)
  end

  def vote_down
    return head 403 if current_user&.author_of?(@resource)

    @resource.downvote!(current_user)
    render_json(@resource)
  end

  private

  def resource
    @resource = model_resource.find(params[:id])
  end

  def model_resource
    controller_name.classify.constantize
  end

  def render_json(resource)
    resource_class = resource.class.name.downcase
    render json: { resource_class: resource_class, resource: resource.id, votes: resource.total_votes }
  end
end
