class AnswersController < ApplicationController
  include ApplicationHelper
  helper_method :resource_authored_by_user?

  before_action :authenticate_user!
  def new
    set_question
    @answer = Answer.new
  end

  def create
    set_question
    @answer = @question.answers.new(params_answer)
    @answer.user_id = current_user.id
    if @answer.save
      redirect_to @answer.question, notice: 'Your answer was accepted'
    else
      @answers = @question.answers.all
      flash[:errors] = @answer.errors.full_messages
      render 'questions/show'
    end
  end

  def destroy
    set_question
    set_answer
    if resource_authored_by_user?(@answer)
      Answer.destroy(@answer.id)
      redirect_to question_path(@question), notice: 'Your answer has been deleted'
    else
      redirect_to question_path(@question), notice: 'You must be author to delete'
    end
  end

  private

  def params_answer
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def set_question
    @question ||= Question.find(params[:question_id])
  end
end
