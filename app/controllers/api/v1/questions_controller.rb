class Api::V1::QuestionsController < Api::V1::BaseController
  skip_authorization_check

  before_action :find_question, only: %i[answers show]

  def index
    questions = Question.all
    render json: questions, each_serializer: QuestionsSerializer
  end

  def answers
    render json: @question.answers, each_serializer: AnswersSerializer
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  private

  def find_question
    @question ||= Question.find(params[:id])
  end
end
