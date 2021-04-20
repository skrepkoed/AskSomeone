class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy edit update]
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(params_answer)
    @answer.author = current_user
    if @answer.save
      @answers = @question.answers
      flash.now[:notice] = 'Your answer was accepted'
    else
      @answers = @question.answers.all
      flash.now[:errors] = @answer.errors.full_messages
    end
    @new_answer=Answer.new
  end
  
  def update
    if current_user.author?(@answer)
      @answer.update(params_answer)
      flash.now[:errors] = @answer.errors.full_messages
    else
      flash.now[:notice] ='You must be author to edit'
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.destroy
      flash.now[:notice] = 'Your answer has been deleted'
    else
      flash.now[:notice] = 'You must be author to delete'
    end
  end

  def delete_attachment
    @answer = Answer.find(params[:answer_id])
    @file_id = params[:file_id]
    
    if current_user.author?(@answer)
      @answer.files.find(params[:file_id]).purge
    else
      flash[:notice] = 'You must be author to delete attachment'
    end
  end

  private

  def params_answer
    params.require(:answer).permit(:body, files:[])
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def set_question
    @question ||= Question.with_attached_files.find(params[:question_id])
  end
end
