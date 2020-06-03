class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true

  scope :positive, -> { where(negative: false) }
  scope :negative, -> { where(negative: true) }
end
