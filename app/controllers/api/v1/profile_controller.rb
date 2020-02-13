class Api::V1::ProfileController < Api::V1::ApiController
  before_action :authenticate_via_token

  def update_profile
    @user.update_attributes(profile_params)
    return render json: {success: true, msg: 'user profile updated..!!'}, status: 200
  end

  def index
  end

  def profile
    return render json: {success: true, data: @user}, status: 200
  end

  private
    def profile_params
      params.fetch(:user, {}).permit(:first_name, :last_name, :profile_url,
          :country, :mobile, :location, :language, :currency, :service_description)
    end
end
