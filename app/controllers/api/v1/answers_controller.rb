class Api::V1::AnswersController<Api::V1::BaseController
  alias :current_user :current_resource_owner
  authorize_resource
  def index
    set_question
    @answers = @question.answers.all
    render json: @answers
  end

  def show
    set_question
    @answer = @question.answers.find(params[:id])
    render json: @answer, serializer: SingleAnswerSerializer
  end

  def create
    set_question
    @answer = @question.answers.new(params_answer)
    @answer.author = current_user
    
    if @answer.save
      @answer.create_rating
    else
      head 401
    end
  end

  def update
    set_question
    @answer = @question.answers.find(params[:id])
    authorize! :update, @answer
    
    if params[:answer] && @answer.update(params_answer)
      render json: @answer, serializer: SingleAnswerSerializer
    else
      head 401
    end
  end

  private

  def params_answer
    params.require(:answer).permit(:body, links_attributes: %i[id name url])
  end

  def set_question
    @question ||= Question.find(params[:question_id])
  end
end