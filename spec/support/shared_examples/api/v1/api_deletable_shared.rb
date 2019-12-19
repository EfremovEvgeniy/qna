shared_examples_for 'Deletable object' do
  it 'deletes object' do
    expect do
      delete api_path, params: { action: :destroy, format: :json, access_token: access_token.token,
                                 object: object.id }
    end.to change(object.class, :count).by(-1)
  end
end
