class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :rewards, dependent: :nullify
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  def author_of?(resource)
    resource.user_id == id
  end

  def voted?(resource)
    resource.votes.exists?(user_id: id)
  end

  def can_vote?(resource)
    return false if author_of?(resource)

    !voted?(resource)
  end
end
