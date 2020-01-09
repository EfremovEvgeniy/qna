require 'rails_helper'

RSpec.describe Subscriber, type: :model do
  it { should belong_to :user }
  it { should belong_to :question }

  describe 'validations' do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }

    it { should validate_presence_of :user }
    it { should validate_presence_of :question }
    it { should validate_uniqueness_of(:question_id).scoped_to([:user_id]) }
  end
end
