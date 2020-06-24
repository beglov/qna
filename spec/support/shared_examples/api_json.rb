shared_examples_for 'json list' do
  let(:json_response) { items_responce.first }

  it 'return list of items' do
    expect(items_responce.size).to eq count_items
  end

  it 'returns all public fields' do
    public_fields.each do |attr|
      expect(json_response[attr]).to eq resource.send(attr).as_json
    end
  end
end
