require 'rails_helper'

RSpec.describe 'Friend Sleeps API', type: :request do
  describe 'GET /api/v1/sleeps' do
    let(:user) { create(:user) }
    let(:friend) { create(:user) }
    let(:friend2) { create(:user) }
    let(:time) { 1.week.ago.beginning_of_week }

    context 'when user friends have sleeping record in previous week' do
      before do
        create(:friendship, user: user, friend: friend)
        create(:friendship, user: user, friend: friend2)

        @clock_in = create(:clock_in, user: friend, time: time + 1.day)
        create(:clock_out, clock_in: @clock_in, time: @clock_in.time + 8.hours)

        @clock_in2 = create(:clock_in, user: friend, time: time + 2.days)
        create(:clock_out, clock_in: @clock_in2, time: @clock_in2.time + 6.hours)

        @clock_in3 = create(:clock_in, user: friend2, time: time + 1.day)
        create(:clock_out, clock_in: @clock_in3, time: @clock_in3.time + 7.hours)

        @clock_in4 = create(:clock_in, user: friend2, time: time + 2.days)
        create(:clock_out, clock_in: @clock_in4, time: @clock_in4.time + 5.hours)
      end

      it 'returns 200' do
        get "/api/v1/users/#{user.id}/friend_sleeps"
        expect(response).to have_http_status(:ok)
      end

      it 'returns previous week the friends sleep and ordered by sleep duration' do
        get "/api/v1/users/#{user.id}/friend_sleeps"
        expect(response.body).to eq([@clock_in, @clock_in3, @clock_in2, @clock_in4].to_json)
      end
    end

    context 'when user does not have any friends' do
      it 'returns 200' do
        get "/api/v1/users/#{user.id}/friend_sleeps"
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty array' do
        get "/api/v1/users/#{user.id}/friend_sleeps"
        expect(response.body).to eq([].to_json)
      end
    end
  end
end
