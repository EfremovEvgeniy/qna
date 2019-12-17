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
