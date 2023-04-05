module Api
  module V1
    class ClockInsController < ApplicationController
      def create
        user = User.find(params[:user_id])

        if user.clock_in!
          render json: user.clocked_in_past_week, status: :created
        else
          render json: { message: 'Please clock out first.' }, status: :unprocessable_entity
        end
      end
    end
  end
end
