class Question < ApplicationRecord
  include Authorable
  include Votable
  include Linkable
  include Commentable

  has_many :answers, -> { order('best DESC, created_at') }, dependent: :delete_all # rubocop:disable Rails/InverseOf
  has_many :subscriptions, dependent: :delete_all
  has_one :reward, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank

  validates :title, :body, presence: true

  after_create :calculate_reputation
  after_create :create_subscription

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end

  def create_subscription
    user.subscriptions.find_or_create_by(question_id: id)
  end
end
