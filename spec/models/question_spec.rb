require 'rails_helper'

RSpec.describe Question, type: :model do
  include_examples 'links associations'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_one(:trophy).dependent(:destroy) }
  it { should belong_to(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :trophy }

  it 'have many attached file' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
