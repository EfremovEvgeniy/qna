class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy update]
  helper_method :answer, :question

  def new; end

  def create
    @answer = question.answers.build(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def destroy
    @answer.destroy if current_user.author_of?(answer)
    redirect_to @answer.question, notice: 'Your answer successfully deleted.'
  end

  def update
    answer.update(answer_params)
    @question = @answer.question
  end

  private

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end
end
