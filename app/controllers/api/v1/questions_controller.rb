class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check

  before_action :find_question, only: :answers

  def index
    questions = Question.all
    render json: questions
  end

  def answers
    render json: @question.answers, each_serializer: AnswerSerializer
  end

  private

  def find_question
    @question ||= Question.find(params[:id])
  end
end
