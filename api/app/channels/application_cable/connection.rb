module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_player

    def connect
      self.current_player = find_verified_player
    end

    private

    def find_verified_player
      auth_header = request.headers["Authorization"]
      reject_unauthorized_connection unless auth_header

      token = auth_header.split(" ").last
      payload = JsonWebToken.decode(token)
      reject_unauthorized_connection unless payload

      Player.find_by(id: payload["player_id"]) ||
        reject_unauthorized_connection
    end
  end
end
