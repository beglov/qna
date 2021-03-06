require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question) }
  let(:user) { create(:user) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:answers).order('best DESC, created_at').dependent(:delete_all) }
    it { should have_many(:links).dependent(:delete_all) }
    it { should have_many(:votes).dependent(:delete_all) }
    it { should have_many(:comments).dependent(:delete_all) }
    it { should have_many(:subscriptions).dependent(:delete_all) }
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

  it_behaves_like 'votable' do
    let(:votable) { create(:question) }
  end

  describe 'reputation' do
    let(:question) { build(:question) }

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end

  describe 'create subscription callback' do
    let(:question) { build(:question) }

    it 'calls create_subscription' do
      expect(question).to receive(:create_subscription)
      question.save!
    end
    it 'user subscribed to question' do
      question.save!
      expect(question.user).to be_subscribed(question)
    end
  end
end
