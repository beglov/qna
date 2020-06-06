require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:answers).order('best DESC, created_at').dependent(:delete_all) }
    it { should have_many(:links).dependent(:delete_all) }
    it { should have_many(:votes).dependent(:delete_all) }
    it { should have_one(:reward).dependent(:destroy) }
  end

  describe 'validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :body }
  end

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :reward }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#rating' do
    it 'return rating value' do
      question.create_positive_vote(create(:user).id)
      question.create_positive_vote(create(:user).id)
      expect(question.rating).to eq 2
    end
  end

  describe '#create_positive_vote' do
    it 'create positive vote' do
      expect {
        question.create_positive_vote(user.id)
      }.to change(question.votes.positive, :count).by(1)
    end
  end

  describe '#create_negative_vote' do
    it 'create negative vote' do
      expect {
        question.create_negative_vote(user.id)
      }.to change(question.votes.negative, :count).by(1)
    end
  end
end
