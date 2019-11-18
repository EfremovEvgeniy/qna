require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to(:linkable) }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }

  it { should allow_value('https://www.google.com/').for(:url) }
  it { should_not allow_value('invalid link').for(:url) }

  describe 'public methods' do
    describe '#gist?' do
      let(:question) { create(:question) }
      let(:link) { create(:link, linkable: question) }
      let(:gist) { create(:link, :gist, linkable: question) }

      it 'check gist to gist' do
        expect(gist).to be_gist
      end

      it 'check link to gist' do
        expect(link).to_not be_gist
      end
    end
  end
end
