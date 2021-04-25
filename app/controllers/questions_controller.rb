class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show destroy edit update]
  def new
    @question = current_user.questions.new
    @question.links.new
    @question.build_achievement
  end

  def create
    @question = current_user.questions.new(params_question)
    if @question.save
      current_user.associate_achievement(@question.achievement)
      flash[:notice] = 'Your question successfully created.'
      redirect_to @question
    else
      flash[:errors] = @question.errors.full_messages
      render :new
    end
  end

  def index
    @questions = Question.all
  end

  def show
    set_new_answer if current_user
    @answers = @question.answers.where.not(id: @question.best_answer_id)
    @best_answer = @question.best_answer
  end

  def update
    if current_user.author?(@question)
      @question.update(params_question)
      flash[:errors] = @question.errors.full_messages
    else
      flash[:notice] ='You must be author to edit'
    end
  end

  def mark_best
    @question = Question.find(params[:question_id])
    @former_best_answer = @question.best_answer
    if current_user.author?(@question) 
      @question.mark_best_answer(params[:answer_id])
    else
      flash[:notice] = 'You must be author to mark answer as best'
    end
  end

  def destroy
    if current_user.author?(@question)
      @question.destroy
      redirect_to questions_path, notice: 'Your question has been deleted'
    else
      render :show, notice: 'You must be author to delete'
    end
  end

  private

  def params_question
    params.require(:question).permit(:title, :body, files:[], links_attributes:[:id, :name, :url, :_destroy],achievement_attributes:[:id,:name,:description,:_destroy,:file])
  end

  def set_question
    @question ||= Question.with_attached_files.find(params[:id])
  end

  def set_new_answer
    @answer = Answer.new(question_id: @question.id, user_id: current_user.id)
  end
end
