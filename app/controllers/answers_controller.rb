class AnswersController < ApplicationController
  def new; end

  def create
    if question.answers.build(answer_params).save
      redirect_to @question
    else
      render :new
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  def question
    @question ||= Question.find(params[:question_id])
  end

  helper_method :answer, :question
end
