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
end
