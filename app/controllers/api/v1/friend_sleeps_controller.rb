module Api
  module V1
    class FriendSleepsController < ApplicationController
      def index
        user = User.find(params[:user_id])
        friend = user.friends.find_by(id: params[:friend_id])

        if friend
          render json: friend.past_week_sleep_records, status: :ok
        else
          render json: { message: 'Friend not found.' }, status: :not_found
        end
      end
    end
  end
end
