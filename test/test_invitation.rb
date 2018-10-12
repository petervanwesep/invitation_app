require 'test/unit'
require_relative '../lib/invitation_app/redis_client'
require_relative '../models/invitation'

class TestInvitation < Test::Unit::TestCase
  def test_create
    uuid = Invitation.create(email_address: 'me@asdf.com')
    assert(InvitationApp::RedisClient.client.get(uuid))
  end

  def test_view
    uuid = Invitation.create(email_address: 'me@asdf.com')
    Invitation.view(uuid)
    invitation = Invitation.fetch(uuid)
    assert(invitation.viewed == true)
  end

  def test_fetch
    uuid = Invitation.create(email_address: 'me@asdf.com')
    invitation = Invitation.fetch(uuid)
    assert(invitation.email_address == 'me@asdf.com')
  end
end
