class Api::V1::AnswersController < Api::V1::BaseController
  skip_authorization_check

  before_action :find_answer, only: %i[show update]
  before_action :find_question, only: :create

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  def create
    answer = @question.answers.build(answer_params)
    answer.user = current_resource_owner
    if answer.save
      render json: answer, status: :created
    else
      render_errors(answer)
    end
  end

  def update
    @answer.update(answer_params)
  end

  private

  def find_answer
    @answer ||= Answer.find(params[:id])
  end

  def find_question
    @question ||= Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body, links_attributes: %i[id name url _destroy])
  end

  def render_errors(answer)
    render json: { errors: answer.errors }, status: :unprocessable_entity
  end
end
