class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order('best DESC, created_at') }, dependent: :delete_all

  has_one_attached :file

  validates :title, :body, presence: true
end
