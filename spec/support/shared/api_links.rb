shared_examples_for 'API links' do
  context 'links' do
    it_behaves_like 'providable public fields' do
      let(:fields_list)     { %w[id name url created_at updated_at] }
      let(:object)          { item.links.first }
      let(:object_response) { json['item']['links'].first }
    end

    it 'returns list of links' do
      expect(json['item']['links'].size).to eq 3
    end
  end
end