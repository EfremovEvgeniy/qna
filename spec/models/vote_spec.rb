require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should validate_presence_of :user }
  it { should validate_presence_of :value }
  it { should validate_inclusion_of(:value).in_array([-1, 1]) }

  describe 'validations uniqueness vote' do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:vote) { create(:vote, user: user, votable: question) }

    it { should validate_uniqueness_of(:user).scoped_to(%i[votable_type votable_id]) }
  end
end
