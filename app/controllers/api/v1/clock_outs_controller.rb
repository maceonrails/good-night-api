module Api
  module V1
    class ClockOutsController < ApplicationController
      def create
        user = User.find(params[:user_id])

        if user.clock_out!
          render json: user.clock_ins, status: :created
        else
          render json: { message: 'Please clock in first.' }, status: :unprocessable_entity
        end
      end
    end
  end
end
