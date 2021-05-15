# frozen_string_literal: true

class Ability
  attr_reader :user

  include CanCan::Ability

  def initialize(user)
    @user = user
    alias_action :pro, :con, to: :vote
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      can :read, :all
    end
  end

  def guest_abilities
    can :read, :all
  end

  def user_abilities
    can %i[edit update destroy index], [Question, Answer], user_id: user.id
    can :mark_best, Question, user_id: user.id
    can %i[create show], [Question, Answer]
    can :create, Comment
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author?(attachment.record)
    end
    can :read, :all
    can :vote, Rating do |rating|
      !user.author?(rating.ratingable)
    end
  end

  def admin_abilities
    can :manage, :all
  end
end
