class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question, only: %i[create]
  before_action :set_answer, only: %i[destroy edit update]
  after_action :publish_answer, only: %i[create]
  authorize_resource
  def new
    @answer = Answer.new
  end

  def create
    @answer = @question.answers.new(params_answer)
    @answer.author = current_user
    if @answer.save
      @answer.create_rating
      @answers = @question.answers
      flash.now[:notice] = 'Your answer was accepted'
    else
      @answers = @question.answers.all
      flash.now[:errors] = @answer.errors.full_messages
    end
    @new_answer = Answer.new
  end

  def update
    @answer.update(params_answer)
    flash[:errors] = @answer.errors.full_messages
  end

  def destroy
    authorize! :destroy, @answer, message: 'You must be author to delete answer'
    @answer.destroy
    flash.now[:notice] = 'Your answer has been deleted'
  end

  private

  def params_answer
    params.require(:answer).permit(:body, files: [], links_attributes: %i[id name url _destroy])
  end

  def set_answer
    @answer ||= Answer.find(params[:id])
  end

  def set_question
    @question ||= Question.with_attached_files.find(params[:question_id])
  end

  def publish_answer
    return unless @answer.valid?

    for_users = ApplicationController.render(
      partial: 'answers/answer_public',
      locals: { answer: @answer }
    )
    variants = { for_users: for_users, id: current_user.id }
    QuestionChannel.broadcast_to(@answer.question, variants)
  end
end
