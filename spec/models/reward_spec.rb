require 'rails_helper'

RSpec.describe Reward, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user).optional }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
  end

  it 'have one attached file' do
    expect(Reward.new.file).to be_an_instance_of(ActiveStorage::Attached::One)
  end
end
