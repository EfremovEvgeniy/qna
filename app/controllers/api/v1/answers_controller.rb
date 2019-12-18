class Api::V1::AnswersController < Api::V1::BaseController
  skip_authorization_check

  before_action :find_answer, only: :show

  def show
    render json: @answer, serializer: AnswerSerializer
  end

  private

  def find_answer
    @answer ||= Answer.find(params[:id])
  end
end