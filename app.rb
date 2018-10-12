require 'sinatra'
require_relative './middleware/jwt_auth'
require_relative './models/invitation'
require_relative './lib/invitation_app/jwt'
require_relative './config'

class Api < Sinatra::Base
  use InvitationApp::Middleware::JwtAuth

  post '/invitations' do
    content_type :json
    if uuid = Invitation.create(params['email_address'])
      status 201 # Object created
      { uuid: uuid }.to_json
    else
      status 422
    end
  end

  get '/invitation/:uuid' do
    content_type :json
    invitation = Invitation.view(params[:uuid])
    if invitation
      invitation.serialize
    else
      status 404
      { message: 'not found' }.to_json
    end
  end
end
