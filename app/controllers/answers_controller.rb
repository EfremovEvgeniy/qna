class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[create destroy update make_best]
  helper_method :answer, :question

  def new; end

  def create
    @answer = question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy if current_user.author_of?(answer)
  end

  def update
    answer.update(answer_params) if current_user.author_of?(answer)
    @question = @answer.question
  end

  def make_best
    @answer.make_best! if current_user.author_of?(answer.question)
  end

  private

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
