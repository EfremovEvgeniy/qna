shared_examples_for 'Creatable object' do
  context 'creates with valid atrributes' do
    it 'creates question' do
      expect do
        do_request(method, api_path, valid_attributes)
      end .to change(object.class, :count).by(1)
    end
    it 'creates question with link' do
      expect do
        do_request(method, api_path, valid_attributes_with_link)
      end .to change(object.class, :count).by(1)
    end
  end

  context 'with invalid attributes' do
    it 'does not create question' do
      expect do
        do_request(method, api_path, invalid_attributes)
      end .to_not change(object.class, :count)
    end

    it 'returns error status' do
      do_request(method, api_path, invalid_attributes)
      expect(response.status).to eq 422
    end
  end
end
