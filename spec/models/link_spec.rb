require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://www.google.com/').for(:url) }
  it { should_not allow_value('invalid link').for(:url) }

  describe 'public methods' do
    describe '#gist_content' do
      let(:question) { create(:question) }
      let(:link) { create(:link, linkable: question) }
      let(:gist) { create(:link, :gist, linkable: question) }
      let(:gist_id) { gist.url.split('/').last }
      let(:gist_service) { double(:gist_service) }

      before do
        allow(GistService).to receive(:new).with(gist_id).and_return(gist_service)
        allow(gist_service).to receive(:content).and_return('my new gist for test')
      end

      it 'return content from gist' do
        expect(gist.gist_content).to eq 'my new gist for test'
      end

      it 'does not return content from not gist' do
        expect(link.gist_content).to be_nil
      end
    end
  end
end
