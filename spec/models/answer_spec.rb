require 'rails_helper'

RSpec.describe Answer, type: :model do
  describe 'associations' do
    it { should belong_to(:question) }
    it { should belong_to(:user) }
    it { should have_many(:links).dependent(:delete_all) }
  end

  describe 'validations' do
    it { should validate_presence_of(:body).with_message("Answer can't be blank") }
  end

  it { should accept_nested_attributes_for :links }

  it 'have many attached files' do
    expect(Answer.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe '#select_best!' do
    let(:question) { create(:question) }
    let(:answer) { create(:answer, question: question) }

    it 'select this answer best' do
      expect(answer).to_not be_best
      answer.select_best!
      expect(answer).to be_best
    end
    it 'deselect other answers' do
      best_answer = create(:answer, question: question, best: true)
      answer.select_best!
      best_answer.reload
      expect(best_answer).to_not be_best
    end
  end
end
