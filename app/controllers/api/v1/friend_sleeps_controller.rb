module Api
  module V1
    class FriendSleepsController < ApplicationController
      def index
        user = User.find(params[:user_id])

        render json: ClockIn.friends_previous_week_sleep_records(user), status: :ok
      end
    end
  end
end
