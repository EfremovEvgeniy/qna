class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!
  after_action :publish_answer, only: :create

  helper_method :answer, :question

  authorize_resource

  def new; end

  def create
    @answer = question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    authorize! :destroy, answer
    @answer.destroy
  end

  def update
    authorize! :update, answer
    @answer.update(answer_params)
    @question = @answer.question
  end

  def make_best
    authorize! :make_best, answer
    @answer.make_best!
  end

  private

  def publish_answer
    return if @answer.errors.any?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}/answers",
      @answer.to_json
    )
  end

  def answer
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  def question
    @question ||= params[:question_id] ?  Question.find(params[:question_id]) : answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end
end
