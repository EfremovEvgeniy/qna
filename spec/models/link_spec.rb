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

      it 'return content from gist' do
        expect(gist.gist_content).to eq 'my new gist for test'
      end

      it 'does not return content from not gist' do
        expect(link.gist_content).to be_nil
      end
    end
  end
end
