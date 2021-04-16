class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i(create)
  before_action :set_answer, only: %i(destroy edit update)
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(params_answer)
    @answer.user_id = current_user.id
    if @answer.save
      @answers = @question.answers
       flash[:notice] = 'Your answer was accepted'
    else
      @answers = @question.answers.all
      flash[:errors] = @answer.errors.full_messages
    end
  end

  def edit
  end

  def update
    @answer.update(params_answer)
    flash[:errors] = @answer.errors.full_messages
  end

  def destroy
    @question=@answer.question
    if current_user.author?(@answer)
      @answer.destroy
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
