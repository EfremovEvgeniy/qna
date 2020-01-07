class SubscribersController < ApplicationController
  before_action :authenticate_user!

  authorize_resource

  def create
    @subscriber = current_user.subscribers.create(question: Question.find(params[:question_id]))
  end

  def destroy
    @subscriber = Subscriber.find(params[:id]).destroy
  end
end
