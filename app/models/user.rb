class User < ApplicationRecord
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :rewards, dependent: :nullify
  has_many :authorizations, dependent: :delete_all
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def author_of?(resource)
    resource.user_id == id
  end

  def voted?(resource)
    resource.votes.exists?(user_id: id)
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid.to_s)
  end
end
