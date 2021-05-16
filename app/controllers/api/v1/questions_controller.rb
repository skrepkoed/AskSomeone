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
    @question = current_resource_owner.questions.new(params_question)
    if @question.save
      render json: @question, serializer: SingleQuestionSerializer 
    end
  end

  def update
    #byebug
    @question = Question.find(params[:id])
    if params[:question] && @question.update(params_question)
      render json: @question, serializer: SingleQuestionSerializer
    else
      head 401
    end
  end

  private

  def params_question
    params.require(:question).permit(:title, :body, links_attributes: %i[id name url])
  end
end