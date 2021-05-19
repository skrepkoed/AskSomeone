class Api::V1::QuestionsController < Api::V1::BaseController
  authorize_resource
  before_action :set_question, only: %i[show update destroy]
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    render json: @question, serializer: SingleQuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.new(params_question)
    render json: @question, serializer: SingleQuestionSerializer if @question.save
  end

  def update
    authorize! :update, @question
    if params[:question] && @question.update(params_question)
      render json: @question, serializer: SingleQuestionSerializer
    else
      head 401
    end
  end

  def destroy
    authorize! :destroy, @question
    @question.destroy
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def params_question
    params.require(:question).permit(:title, :body, links_attributes: %i[id name url])
  end
end
