class RatingsController < ApplicationController
  before_action :authenticate_user!

  def pro
    @rating = Rating.find(params[:id])
    @vote = @rating.find_user_vote(current_user).account_vote(1)
    respond_to do |format|
      if @vote.errors.empty?
        @rating.save
        format.json { render json: @rating }
      else
        format.json { render json: @vote.errors.first[1], status: :unprocessable_entity }
      end
    end
  end

  def con
    @rating = Rating.find(params[:id])
    @vote = @rating.find_user_vote(current_user).account_vote(-1)
    respond_to do |format|
      if @vote.errors.empty?
        @rating.save
        format.json { render json: @rating }
      else
        format.json { render json: @vote.errors.first[1], status: :unprocessable_entity }
      end
    end
  end
end
