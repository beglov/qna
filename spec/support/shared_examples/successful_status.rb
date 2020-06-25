shared_examples_for 'successful status' do
  it 'returns 20X status' do
    expect(response).to be_successful
  end
end
