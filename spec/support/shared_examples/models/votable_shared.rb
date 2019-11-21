require 'rails_helper'

shared_examples_for Votable do
  describe 'Associations' do
    it { should have_many(:votes).dependent(:destroy) }
  end

  describe 'public methods' do
    describe '#total_votes' do
      let!(:vote1) { create(:vote, user: second_user, votable: votable, value: 1) }
      let!(:vote2) { create(:vote, user: third_user, votable: votable, value: 1) }
      it 'count sum values' do
        expect(votable.total_votes).to eq 2
      end
    end

    describe '#upvote!' do
      it 'user votes up one time' do
        votable.upvote!(second_user)

        expect(votable.total_votes).to eq 1

        votable.upvote!(second_user)

        expect(votable.total_votes).to eq 1
      end

      it 'user changes his vote' do
        votable.upvote!(second_user)

        expect(votable.total_votes).to eq 1

        votable.downvote!(second_user)

        expect(votable.total_votes).to eq(-1)
      end
    end

    describe '#downvote!' do
      it 'user votes down one time' do
        votable.downvote!(second_user)

        expect(votable.total_votes).to eq(-1)

        votable.downvote!(second_user)

        expect(votable.total_votes).to eq(-1)
      end

      it 'user changes his vote' do
        votable.downvote!(second_user)

        expect(votable.total_votes).to eq(-1)

        votable.upvote!(second_user)

        expect(votable.total_votes).to eq 1
      end
    end
  end
end
