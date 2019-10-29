class AnswersController < ApplicationController
  before_action :find_question, only: %i[create]
  def new;end

  def create
    @question.answers.build(answer_params).save
  end


  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

end
