module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :delete_all
  end

  def rating
    votes.sum(:vote)
  end

  def create_positive_vote(user_id)
    votes.create_with(vote: 1).find_or_create_by(user_id: user_id)
  end

  def create_negative_vote(user_id)
    votes.create_with(vote: -1).find_or_create_by(user_id: user_id)
  end
end
