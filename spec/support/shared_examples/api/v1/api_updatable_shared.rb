shared_examples_for 'Updatable object' do
  context 'with valid atrributes' do
    let(:access_token) { create(:access_token, resource_owner_id: object.user.id) }
    let!(:link) { create(:link, linkable: object) }

    it 'updates object' do
      do_request(method, api_path, valid_attributes)
      expect(object.reload.body).to eq 'new body'
      expect(response).to be_successful
    end

    it 'deletes link from object' do
      do_request(method, api_path, valid_attributes_with_link)
      expect(object.reload.links.count).to be_zero
      expect(response).to be_successful
    end
  end

  context 'with invalid attributes' do
    it 'does not update object attributes' do
      expect do
        do_request(method, api_path, invalid_attributes)
      end .to_not change(object.reload, :body)
      expect(response.status).to eq 422
    end
  end
end
