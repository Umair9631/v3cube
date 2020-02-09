class Api::V1::ApiController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :authenticate_via_token
  around_action :set_time_zone

  private
    def authenticate_via_token
      if request.headers[:Authorization].blank?
        return render json: { success: false, msg: 'Authentication token not found.' }, status: 401
      end

      @token = request.headers[:Authorization]
      hmac_secret = "85d5a031571d83e028e8b62c670e21837e72e84597ced309d9a898e2d22e0195111c85204e2edbad92633446e214760d216ad44805a1a07938f563280c710600"
      begin
        @decoded_token = JWT.decode @token, hmac_secret, true, { algorithm: 'HS256' }
        @user = User.find_by(id: @decoded_token.first["data"]["user"]["id"])

        if !@user
          return render json: {success: false, msg: 'Invalid token.'}, status: 401
        end

      rescue JWT::ExpiredSignature
        return render json: {success: false, msg: 'Token has expired.'}, status: 401

      rescue Exception => e
        return render json: {success: false, msg: e.message}, status: 401
      end
    end

    def set_time_zone
      if @user.nil?
        yield
      else
        Time.use_zone(@user.time_zone) do
          yield
        end
      end
    end
end
