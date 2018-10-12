# Via: https://auth0.com/blog/ruby-authentication-secure-rack-apps-with-jwt/

module InvitationApp
  module Middleware
    class JwtAuth
      def initialize(app)
        @app = app
      end

      def call(env)
        return @app.call(env) if env.fetch('REQUEST_METHOD') == 'OPTIONS'

        begin
          bearer = env.fetch('HTTP_AUTHORIZATION', '').slice(7..-1) # REMOVE "BEARER "
          payload, header = InvitationApp::Jwt.decode(bearer)
          # No data yet included inside the JWT
          @app.call(env)
        rescue JWT::DecodeError
          [401, { 'Content-Type' => 'text/plain' }, ['A token must be passed.']]
        rescue JWT::ExpiredSignature
          [403, { 'Content-Type' => 'text/plain' }, ['The token has expired.']]
        rescue JWT::InvalidIssuerError
          [403, { 'Content-Type' => 'text/plain' }, ['The token does not have a valid issuer.']]
        rescue JWT::InvalidIatError
          [403, { 'Content-Type' => 'text/plain' }, ['The token does not have a valid "issued at" time.']]
        end
      end
    end
  end
end
