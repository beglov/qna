class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user
    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guest_abilities
    end
  end

  private

  def guest_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guest_abilities
    can :me, User
    can :create, [Question, Answer, Comment]
    can :update, [Question, Answer, Comment], user_id: user.id
    can :destroy, [Question, Answer, Comment], user_id: user.id
    can :destroy, ActiveStorage::Attachment do |attachment|
      user.author_of?(attachment.record)
    end
    can :destroy, Link do |link|
      user.author_of?(link.linkable)
    end
    can [:up, :down], [Question, Answer] do |resource|
      !user.author_of?(resource)
    end
    can :cancel_vote, [Question, Answer]
    can %i[subscribe unsubscribe], Question
    can :select_best, Answer, user_id: user.id
  end
end
