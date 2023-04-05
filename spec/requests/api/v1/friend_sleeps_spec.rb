require 'rails_helper'

RSpec.describe 'Friend Sleeps API', type: :request do
  describe 'GET /api/v1/sleeps' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }

    context 'when user is friends with friend' do
      before do
        create(:friendship, user: user, friend: friend)

        time = 1.day.ago
        @clock_in = create(:clock_in, user: friend, time: time)
        create(:clock_out, clock_in: @clock_in, time: time + 8.hours)

        time2 = 2.days.ago
        @clock_in2 = create(:clock_in, user: friend, time: time2)
        create(:clock_out, clock_in: @clock_in2, time: time2 + 6.hours)

        time3 = 8.days.ago
        @clock_in3 = create(:clock_in, user: friend, time: time3)
        create(:clock_out, clock_in: @clock_in3, time: time3 + 4.hours)
      end

      it 'returns 200' do
        get "/api/v1/users/#{user.id}/friends/#{friend.id}/sleeps"
        expect(response).to have_http_status(:ok)
      end

      it 'returns past week the friend sleep and ordered by sleep duration' do
        get "/api/v1/users/#{user.id}/friends/#{friend.id}/sleeps"
        expect(response.body).to eq([@clock_in, @clock_in2].to_json)
      end
    end

    context 'when user is not friends with friend' do
      it 'returns 404' do
        get "/api/v1/users/#{user.id}/friends/#{friend.id}/sleeps"
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
