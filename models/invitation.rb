require 'securerandom'
require 'json'
require_relative '../lib/invitation_app/redis_client'

class Invitation
  attr_accessor :email_address, :viewed

  def self.create(email_address)
    uuid = SecureRandom.uuid
    invitation = Invitation.new(email_address)
    invitation.save(uuid)
    uuid
  end

  def self.view(uuid)
    invitation = fetch(uuid)
    if invitation
      invitation.viewed = true
      invitation.save(uuid)
      invitation
    end
  end

  def self.fetch(uuid)
    json_obj = get(uuid)
    if json_obj
      Invitation.new(json_obj['email_address'], json_obj['viewed'])
    end
  end

  def initialize(email_address, viewed=false)
    @email_address = email_address
    @viewed = viewed
  end

  def save(uuid)
    InvitationApp::RedisClient.client.set(uuid, self.serialize)
  end

  def serialize
    attributes.to_json
  end

  private

  def attributes
    {
      email_address: @email_address,
      viewed: @viewed
    }
  end

  def self.get(uuid)
    serialized_invitation = InvitationApp::RedisClient.client.get(uuid)
    JSON.parse(serialized_invitation) if serialized_invitation
  end
end
