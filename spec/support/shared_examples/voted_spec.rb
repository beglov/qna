require 'rails_helper'

shared_examples_for 'voted' do
  before { login(user) }

  describe 'POST #up' do
    context 'author' do
      it 'not create vote' do
        expect {
          post :up, params: {id: user_votable}
        }.to_not change(Vote, :count)
      end
    end

    context 'not author' do
      it 'create positive vote' do
        expect {
          post :up, params: {id: votable}
        }.to change(votable.votes.positive, :count).by(1)
      end
    end
  end

  describe 'POST #down' do
    context 'author' do
      it 'not create vote' do
        expect {
          post :down, params: {id: user_votable}
        }.to_not change(Vote, :count)
      end
    end

    context 'not author' do
      it 'create negative vote' do
        expect {
          post :down, params: {id: votable}
        }.to change(votable.votes.negative, :count).by(1)
      end
    end
  end

  describe 'POST #cancel_vote' do
    before { votable.create_negative_vote(user.id) }

    it 'delete vote' do
      expect {
        post :cancel_vote, params: {id: votable}
      }.to change(votable.votes.negative, :count).by(-1)
    end
  end
end
