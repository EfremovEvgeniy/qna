class AnswersController < ApplicationController
  before_action :authenticate_user!, only: %i[create destroy]
  helper_method :answer, :question

  def new; end

  def create
    @new_answer = question.answers.build(answer_params)
    @new_answer.user = current_user
    if @new_answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      # byebug
      render 'questions/show'
    end
  end

  def destroy
    @answer.destroy if current_user.author_of?(answer)
    redirect_to @answer.question, notice: 'Your answer successfully deleted.'
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
