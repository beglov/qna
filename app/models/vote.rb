class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true

  scope :positive, -> { where('vote > 0') }
  scope :negative, -> { where('vote < 0') }
end
