require 'jwt'

module InvitationApp
  class Jwt
    def self.encode(payload)
      JWT.encode(payload, JWT_SECRET, JWT_KEY_ALGORITHM)
    end

    def self.decode(token)
      JWT.decode(token, JWT_SECRET, true, { algorithm: JWT_KEY_ALGORITHM })
    end
  end
end
