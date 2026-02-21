# app/controllers/api/v1/auth_controller.rb
module Api
  module V1
    class AuthController < ApplicationController
      before_action :authorize_request, only: [:profile]

      def register
        player = Player.new(player_params)
        if player.save
          token = ::JsonWebToken.encode(player_id: player.id)
          render json: { token: token, username: player.username }, status: :created
        else
          render json: { errors: player.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def profile
        render json: @current_player.resume
      end

      private

      def authorize_request
        header = request.headers['Authorization']
        header = header.split(' ').last if header
        decoded = ::JsonWebToken.decode(header)
        p decoded
        @current_player = Player.find_by(id: decoded[:player_id]) if decoded
        render json: { errors: ['Not Authorized'] }, status: :unauthorized unless @current_player
      end

      def player_params
        params.require(:player).permit(:username) 
      end
    end
  end
end
