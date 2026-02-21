module Api
  module V1
    class GameModesController < ApplicationController

      def index
        render json: { game_modes: GameConfiguration.game_modes.keys }, status: :ok
      end
    end
  end
end