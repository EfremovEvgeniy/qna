shared_examples_for 'API Authorizable' do
  context 'unauthorazed' do
    it 'returns 401 if there is no access token' do
      do_request(method, api_path, headers: headers)

      expect(response.status).to eq 401
    end
    it 'returns 401 if access token invalid' do
      do_request(method, api_path, params: { access_token: 'token' }, headers: headers)

      expect(response.status).to eq 401
    end
  end
end

shared_examples_for 'Successful response' do
  it 'returns 200 status' do
    expect(response).to be_successful
  end
end

shared_examples_for 'Returns list of objects' do
  it 'returns list of objects' do
    expect(given_response.size).to eq count
  end
end

shared_examples_for 'API Authorizable with attributes' do
  context 'unauthorized with object attributes' do
    let(:access_token) { create(:access_token) }
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, params: { action: :destroy, format: :json,
                                             factory: attributes_for(factory) })

      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { action: :destroy, access_token: '1234', format: :json,
                                             factory: attributes_for(factory) })
      expect(response.status).to eq 401
    end

    it 'returns 401 status if user not author' do
      do_request(method, api_path, params: { action: :destroy, access_token: access_token, format: :json,
                                             factory: attributes_for(factory) })
      expect(response.status).to eq 401
    end
  end
end
