class QuestionsController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  helper_method :question
  after_action :publish_question, only: :create

  authorize_resource

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @answer.links.build
    gon.question_id = question.id
  end

  def new
    question.links.build
    @question.build_trophy
  end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      gon.question_id = @question.id
      redirect_to questions_path, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    authorize! :update, question
    @question.update(question_params)
  end

  def destroy
    authorize! :destroy, question
    @question.destroy
    redirect_to questions_path, notice: 'The question is successfully deleted.'
  end

  private

  def publish_question
    return if @question.errors.any?

    ActionCable.server.broadcast(
      'questions_channel',
      @question.to_json
    )
  end

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
                                                    links_attributes: %i[id name url _destroy],
                                                    trophy_attributes: %i[name image _destroy])
  end
end
