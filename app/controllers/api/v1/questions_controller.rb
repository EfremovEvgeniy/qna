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

  def create
    question = current_resource_owner.questions.build(question_params)

    if question.save
      render json: question, status: :created
    else
      render_errors(question)
    end
  end

  private

  def find_question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[id name url _destroy])
  end

  def render_errors(question)
    render json: { errors: question.errors }, status: :unprocessable_entity
  end
end
