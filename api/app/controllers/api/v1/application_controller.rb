module Api
  module V1
    class ApplicationController < ActionController::API
      attr_reader :current_player

      private

      def authenticate_player!
        token = bearer_token
        return render_unauthorized unless token

        payload = JsonWebToken.decode(token)
        return render_unauthorized unless payload

        @current_player = Player.find_by(id: payload[:player_id])
        render_unauthorized unless @current_player
      end

      def bearer_token
        header = request.headers["Authorization"]
        return nil unless header

        header.split(" ").last
      end

      def render_unauthorized
        render json: { error: "Unauthorized" }, status: :unauthorized
      end
    end
  end
end
