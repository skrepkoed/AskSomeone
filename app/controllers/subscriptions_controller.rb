class SubscriptionsController < ApplicationController
  before_action :set_question
  def create
    @subscription = Subscription.create(user: current_user, question:@question)
    render :subscription
  end

  def destroy
    @subscription = Subscription.find_by(question:@question, user: current_user).destroy
    render :subscription
  end

  private

  def set_question
    @question = Question.find(params[:question_id])
  end
end
