class RatingsController < ApplicationController
  before_action :authenticate_user!
  
  def pro
    @rating = Rating.find(params[:id])
    @question = Object.const_get(@rating.ratingable_type).find(@rating.ratingable_id)
    @question.account_vote(current_user, 1)
    @rating.pro
    if @rating.save
      respond_to do |format|
        format.json {render json: @rating}
      end
    end
  end

  def con
    @rating = Rating.find(params[:id])
    @question = @rating.question
    @question.account_vote(current_user, -1)
    @rating.con
  end
end
