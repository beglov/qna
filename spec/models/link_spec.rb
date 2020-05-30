require 'rails_helper'

RSpec.describe Link, type: :model do
  describe 'associations' do
    it { should belong_to(:linkable) }
  end

  describe 'validations' do
    it { should validate_presence_of :name }
    it { should validate_presence_of :url }
    it { should allow_values('http://foo.com', 'https://foo.com').for(:url) }
  end

  describe '#gist?' do
    let(:link_to_gist) { create(:link, url: 'https://gist.github.com/beglov/736817e4f485da27bf995a6bda7fb7a9') }
    let(:link) { create(:link) }

    it 'link to gist' do
      expect(link_to_gist).to be_gist
    end
    it 'lint to not gist' do
      expect(link).to_not be_gist
    end
  end
end
