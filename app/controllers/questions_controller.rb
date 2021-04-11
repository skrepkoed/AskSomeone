class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(params_question)
    if @question.save
      redirect_to @question
    else
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def show
    set_question
  end

  private

  def params_question
    params.require(:question).permit(:title, :body)
  end

  def set_question
    @question ||= Question.find(params[:id])
  end
end
