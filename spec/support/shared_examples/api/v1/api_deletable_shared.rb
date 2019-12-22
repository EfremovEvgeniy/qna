shared_examples_for 'Deletable object' do
  let(:request) do
    delete api_path, params: { action: :destroy, format: :json, access_token: access_token.token,
                               object: object.id }
  end
  it 'deletes object' do
    expect do
      request
    end.to change(object.class, :count).by(-1)
  end

  it 'returns success response' do
    request
    expect(response).to be_successful
  end
end
