require 'rails_helper'

shared_examples_for Voted do
  describe 'POST #create' do
    context 'Authenticated user not author resource' do
      before { login_with(second_user) }

      it 'create vote up' do
        expect { post :vote_up, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
      end

      it 'create vote down' do
        expect { post :vote_down, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(1)
      end
    end

    context 'Authenticated user author resource' do
      before { login_with(votable.user) }

      it 'create vote up for author' do
        expect { post :vote_up, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(0)
      end

      it 'render head 403 for Up' do
        post :vote_up, params: { id: votable, format: :json }

        expect(response).to have_http_status 403
      end

      it 'create vote down for author' do
        expect { post :vote_down, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(0)
      end

      it 'render head 403 for Down' do
        post :vote_down, params: { id: votable, format: :json }

        expect(response).to have_http_status 403
      end
    end

    context 'Unauthenticated user' do
      it 'vote up' do
        expect { post :vote_up, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(0)
      end

      it 'vote down' do
        expect { post :vote_down, params: { id: votable, format: :json } }.to change(votable.votes, :count).by(0)
      end
    end
  end
end
