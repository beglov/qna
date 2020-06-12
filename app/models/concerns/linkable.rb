module Linkable
  extend ActiveSupport::Concern

  included do
    has_many :links, as: :linkable, dependent: :delete_all
  end
end
