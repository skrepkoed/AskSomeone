class Api::V1::QuestionsController<Api::V1::BaseController
  def index
    @questions = Question.all
    render json: @questions
  end

  def show
    @question = Question.find(params[:id])
    render json: @question, serializer: SingleQuestionSerializer
  end
  
  def create
    @question = current_resource_owner.questions.new(question_params)
    if @question.save
      render json: @question, serializer: SingleQuestionSerializer 
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: %i[id name url]) if params[:question]
  end
end