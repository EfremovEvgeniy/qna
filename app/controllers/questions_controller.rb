class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  helper_method :question

  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
  end

  def new; end

  def edit; end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to questions_path, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to @question
    else
      render :edit
    end
  end

  def destroy
    question.destroy if current_user.author_of?(question)
    redirect_to questions_path, notice: 'The question is successfully deleted.'
  end

  private

  def question
    @question ||= params[:id] ? Question.find(params[:id]) : Question.new
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end
end
