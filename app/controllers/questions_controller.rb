class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params_question)
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
    set_new_answer
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
    @answer = @question.answers.new
  end
end
