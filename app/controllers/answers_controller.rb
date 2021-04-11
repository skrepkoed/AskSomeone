class AnswersController < ApplicationController
  def new
    @answer = Answer.new
  end

  def create
    set_question
    @answer = @question.answers.new(params_answer)
    if @answer.save
      redirect_to @answer.question, notice: 'Your answer was accepted'
    else
      flash[:errors] = @answer.errors.full_messages
      render 'questions/show'
    end
  end

  private

  def params_answer
    params.require(:answer).permit(:body)
  end

  def set_question
    @question ||= Question.find(params[:question_id])
  end
end
