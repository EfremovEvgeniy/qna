class AnswersController < ApplicationController
  helper_method :answer, :question

  def new; end

  def create
    answer = question.answers.build(answer_params)
    if answer.save
      redirect_to @question, notice: 'Your answer successfully created.'
    else
      render :new
    end
  end

  def destroy
    answer.destroy
    redirect_to request.referrer, notice: 'Your answer successfully deleted.'
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
