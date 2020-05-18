require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:questions).dependent(:nullify) }
    it { should have_many(:answers).dependent(:nullify) }
  end

  describe 'validations' do
    it { should validate_presence_of :email }
    it { should validate_presence_of :password }
  end

  it '#author_of?' do
    user = create(:user)
    expect(user).to_not be_author_of(create(:question))
    expect(user).to be_author_of(user.questions.create(attributes_for(:question)))
  end
end
