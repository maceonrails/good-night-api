module Api
  module V1
    class FriendsController < ApplicationController
      before_action :set_user

      def create
        friend = User.find(params[:friend_id])

        if @user.follow!(friend)
          render json: { message: 'Followed.' }, status: :created
        else
          render json: { message: 'Already following.' }, status: :unprocessable_entity
        end
      end

      def destroy
        friend = User.find(params[:id])

        if @user.unfollow!(friend)
          render json: { message: 'Unfollowed.' }, status: :ok
        else
          render json: { message: 'Not following.' }, status: :unprocessable_entity
        end
      end

      private

      def set_user
        @user = User.find(params[:user_id])
      end
    end
  end
end
