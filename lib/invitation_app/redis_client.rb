require 'fakeredis'

module InvitationApp
  class RedisClient
    def self.client
      @@client ||= Redis.new
    end
  end
end
