class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order('best DESC, created_at') }, dependent: :delete_all
  has_many :links, as: :linkable, dependent: :delete_all
  has_many :votes, as: :votable, dependent: :delete_all
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  def rating
    votes.positive.count - votes.negative.count
  end
end
