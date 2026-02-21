module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_verified_player
    end

    private

    def find_verified_player
      # 🔑 On récupère le token depuis l'URL
      token = request.params[:token].presence
      p token
      reject_unauthorized_connection unless token

      payload = JsonWebToken.decode(token)
      reject_unauthorized_connection unless payload

      p payload
      player = Player.find_by(id: payload["player_id"])
      reject_unauthorized_connection unless player

      player
    rescue JWT::DecodeError, JWT::ExpiredSignature
      reject_unauthorized_connection
    end
  end
end