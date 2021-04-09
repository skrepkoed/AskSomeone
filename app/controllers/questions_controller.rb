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

  private

  def params_question
    params.require(:question).permit(:title, :body)
  end
end
