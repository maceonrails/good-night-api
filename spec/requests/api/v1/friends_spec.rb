require 'rails_helper'

RSpec.describe 'Friends API', type: :request do
  describe 'POST /api/v1/friends' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    context 'when user is not friends with friend' do
      it 'returns 201' do
        post "/api/v1/users/#{user.id}/friends", params: { friend_id: friend.id }
        expect(response).to have_http_status(:created)
      end

      it 'creates a friendship' do
        expect { post "/api/v1/users/#{user.id}/friends", params: { friend_id: friend.id } }
          .to change { user.friends.count }.by(1)
      end

      it 'returns a success message' do
        post "/api/v1/users/#{user.id}/friends", params: { friend_id: friend.id }
        expect(response.body).to eq({ message: 'Followed.' }.to_json)
      end
    end

    context 'when user is friends with friend' do
      before { create(:friendship, user: user, friend: friend) }

      it 'returns 422' do
        post "/api/v1/users/#{user.id}/friends", params: { friend_id: friend.id }
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not create a friendship' do
        expect { post "/api/v1/users/#{user.id}/friends", params: { friend_id: friend.id } }
          .not_to(change { user.friends.count })
      end

      it 'returns an error message' do
        post "/api/v1/users/#{user.id}/friends", params: { friend_id: friend.id }
        expect(response.body).to eq({ message: 'Already following.' }.to_json)
      end
    end
  end

  describe 'DELETE /api/v1/friends' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    context 'when user is friends with friend' do
      before { create(:friendship, user: user, friend: friend) }

      it 'returns 200' do
        delete "/api/v1/users/#{user.id}/friends/#{friend.id}"
        expect(response).to have_http_status(:ok)
      end

      it 'destroys the friendship' do
        expect { delete "/api/v1/users/#{user.id}/friends/#{friend.id}" }
          .to change { user.friends.count }.by(-1)
      end

      it 'returns a success message' do
        delete "/api/v1/users/#{user.id}/friends/#{friend.id}"
        expect(response.body).to eq({ message: 'Unfollowed.' }.to_json)
      end
    end

    context 'when user is not friends with friend' do
      it 'returns 422' do
        delete "/api/v1/users/#{user.id}/friends/#{friend.id}"
        expect(response).to have_http_status(:unprocessable_entity)
      end

      it 'does not destroy a friendship' do
        expect { delete "/api/v1/users/#{user.id}/friends/#{friend.id}" }
          .not_to(change { user.friends.count })
      end
    end
  end
end
