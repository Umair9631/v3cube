module Api::V1::UsersHelper
  def get_jwt_token user
    hmac_secret = "85d5a031571d83e028e8b62c670e21837e72e84597ced309d9a898e2d22e0195111c85204e2edbad92633446e214760d216ad44805a1a07938f563280c710600"
    payload = { data: {user: {id: user.id, email: user.email, name: user.name}} }
    payload[:exp] = (Time.now + 10.days).to_i
    JWT.encode payload, hmac_secret, 'HS256'
  end
end
