require 'rails_helper'

describe GistService do
  let(:gist_id) { '4d7ba68e703433abb537d9c193b0af4c' }
  let(:ivnalid_gist_id) { 'b287192731899sa9d8798327498f9s9c98239891' }
  let(:gist_service) { described_class.new(gist_id) }
  let(:second_gist_service) { described_class.new(ivnalid_gist_id) }

  describe 'intialization' do
    it 'assigns gists accessor' do
      expect(gist_service.gist_id).to eq gist_id
      expect(second_gist_service.gist_id).to eq ivnalid_gist_id
    end
  end

  describe 'public methods' do
    describe '#content' do
      it 'get content' do
        expect(gist_service.content).to eq 'my new gist for test'
      end

      it 'does not get content' do
        expect(second_gist_service.content).to be_nil
      end
    end
  end
end
