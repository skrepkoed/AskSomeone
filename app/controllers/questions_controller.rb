class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i(index show)
  def new
    @question = current_user.questions.new
  end

  def create
    @question = current_user.questions.new(params_question)
    if @question.save
      redirect_to @question, notice: "Your question successfully created."
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def show
    set_question
    set_new_answer if current_user
    @answers = @question.answers.all
  end

  private

  def params_question
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question ||= Question.find(params[:id])
  end

  def set_new_answer
    @answer = Answer.new(question_id:@question.id, user_id:current_user.id)
  end
end
