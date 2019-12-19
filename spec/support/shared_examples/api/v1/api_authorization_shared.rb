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
