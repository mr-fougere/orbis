module Api
  module V1
    class GamesController < ApplicationController
      before_action :authenticate_player!

      def create
        game = GameBuilder.new(game_configuration: game_create_params, admin_player: @current_player).build!
        render json: { code: game.code }, status: :created
      end

      private 

      def game_create_params
        params.require(:game_configuration).permit(
          :game_mode,
          board: [:width, :height],
          initial_disks: [:x, :y, :side],
        )
      end
    end
  end
end