class Api::V1::AnswersController<Api::V1::BaseController
  def index
    set_question
    @answers = @question.answers.all
    render json: @answers
  end

  private

  def set_question
    @question ||= Question.find(params[:question_id])
  end
end