class SubscribersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: :create

  authorize_resource

  def create
    @subscriber = current_user.subscribers.create(question: @question)
  end

  def destroy
    @subscriber = Subscriber.find(params[:id]).destroy
  end

  private

  def find_question
    @question ||= Question.find(params[:question_id])
  end
end
