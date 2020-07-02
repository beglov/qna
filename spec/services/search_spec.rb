require 'rails_helper'

RSpec.describe Services::Search do
  context 'global search' do
    it 'calls ThinkingSphinx.search' do
      expect(ThinkingSphinx).to receive(:search).with(ThinkingSphinx::Query.escape('search_query'))
      Services::Search.new('All', 'search_query').call
    end
  end

  context 'per model' do
    it 'calls Question.search' do
      expect(Question).to receive(:search).with(ThinkingSphinx::Query.escape('search_query'))
      Services::Search.new('Question', 'search_query').call
    end
  end
end
