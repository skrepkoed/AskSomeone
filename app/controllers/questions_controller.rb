class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy edit update]
  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(params_question)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      flash[:errors] = @question.errors.full_messages
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def show
    set_new_answer if current_user
    @answers = @question.answers.all
  end

  def edit
  end

  def update
    @question.update(params_question)
    flash[:errors] = @question.errors.full_messages
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question has been deleted'
    else
      render :show, notice: 'You must be author to delete'
    end
  end

  private

  def params_question
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question ||= Question.find(params[:id])
  end

  def set_new_answer
    @answer = Answer.new(question_id: @question.id, user_id: current_user.id)
  end
end
