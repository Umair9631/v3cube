require 'twilio-ruby'
class Api::V1::UsersController < Api::V1::ApiController
  include Api::V1::UsersHelper
  skip_before_action :authenticate_via_token, only: [:signin, :signup, :forgotpassword, :verify]

  #####################################################################
  ## Function:    signin
  ## Endpoint:    [POST]/users/signin
  ## Params:      @email
  ##              @password
  #####################################################################
  def signin
    email     = params[:email]
    password  = params[:password]

    #  Check required params
    ## Email & password is required
    if email.blank? || password.blank?
      return render json: { success: false, msg: 'Email and Password is required.' }, status: 200
    end

    # Fetch user by email
    @user = User.find_by(email: email)
    return render json: { success: false, msg: 'Invalid email / password.' }, status: 200 unless @user

    # Check if user is active

    ## User found, check password and proceed
    if @user.valid_password?(password)
      token = get_jwt_token(@user)

      ## Update user with token
      @user.update_attributes(jwt_token: token, status: true)

      return render json: { success: true, msg: 'User assigned authentication token.', data: {user: @user}} , status: 200
    else
      return render json: { success: false, msg: 'Invalid email / password.' }, status: 200
    end
  end

  #####################################################################
  ## Function:    signup
  ## Endpoint:    [POST]/users/signup
  ## Params:      @email
  #####################################################################
  def signup
    email           = params[:user][:email]
    password        = params[:user][:password]
    role            = params[:user][:role]
    otp_code        = rand(1000..9999)
    @user           = User.new(email: email, password: password, verification_code: otp_code)

    # @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_KEY'])

    if email.blank?
      return render json: { success: false, msg: 'Email address is required.' }, status: 200
    end

    if @user.save
      if role == 1
        @user.add_role :service_user
      else
        @user.add_role :service_provider
      end
      # @client.messages.create(
      #     from: ENV['TWILIO_PHONE'],
      #     to: "#{params[:user][:country] + params[:user][:mobile]}",
      #     body: "Security Code for Work Grab: #{otp_code}"
      #   )
      @user.update_attributes(profile_params)
      UserMailer.new_signup(@user).deliver_now

      return render json: {success: true, msg: 'User created successfully.', data: @user}, status: 200
    else
      return render json: { success: false, msg: 'Sorry! the email address already exists.' }, status: 200
    end
  end

  #####################################################################
  ## Function:    forgotpassword
  ## Endpoint:    [POST]/users/forgotpassword
  ## Params:      @email
  ## Description: If email is verified, reset password email with token is sent to user.
  #####################################################################
  def forgotpassword
    email = params[:email]

    #  Check required params
    ## Email is required
    if email.blank?
      return render json: { success: false, msg: 'Email is required.' }, status: 200
    end

    # Fetch user by email
    @user = User.where(email: email)
    if !@user.any?
      return render json: { success: false, msg: 'Email not found.' }, status: 200
    end
    @user = @user.first

    @user.send_reset_password_instructions
    return render json: { success: true, msg: 'Reset password email has been sent.' }, status: 200
  end


  #####################################################################
  ## Function:    resetpassword
  ## Endpoint:    [POST]/users/resetpassword
  ## Params:      @token
  ##              @password
  ## Description: If token is matched, password is updated
  #####################################################################
  def resetpassword
    token = params[:token]
    password = params[:password]

    #  Check required params
    ## Email is required
    if token.blank? || password.blank?
      return render json: { success: false, msg: 'Token and Password is required.' }, status: 200
    end

    # Fetch user by token
    @user = User.find_by(reset_password_token: token)
    if @user
      @user.password = password
      @user.reset_password_token = nil
      @user.save
      return render json: { success: true, msg: 'Password reset sucessfully.' }, status: 200
    else
      return render json: { success: false, msg: 'Invalid token.' }, status: 200
    end
  end


  #####################################################################
  ## Function:    update_password
  ## Endpoint:    [POST]/users/update_password
  ## Params:      @current_password
  ##              @new_password
  ##
  ## Description: It will update the user's password in database by verifying the current password.
  #####################################################################
  def update_password
    current_password  = params[:current_password]
    new_password      = params[:new_password]

    if current_password.blank? || new_password.blank?
      return render json: { success: false, msg: 'Current password is required.' }, status: 200
    end

    if @user.valid_password?(current_password)
      @user.password = new_password
      @user.save!

      return render json: { success: true, msg: 'Password updated sucessfully.' }, status: 200
    else
      return render json: { success: false, msg: 'Current password is not valid.' }, status: 200
    end

  end

  def verify
    code = params[:code]
    email = params[:email]

    @user = User.find_by(email: email)

    if @user.verification_code == code
      @user.verification_code = ''
      @user.otp_verified = true
      return render json: { success: true, msg: 'Your phone has been verified now.' }, status: 200
    else
      return render json: { success: false, msg: 'Wrong security Code...' }, status: 401
    end
  end

  def signout
    @user.update_logout_details()

    return render json: { success: true, msg: 'You have been logged out successfully.' }, status: 200
  end

  private
    def profile_params
      params.fetch(:user, {}).permit(:first_name, :last_name, :username, :email, :password, :profile_url,
          :country, :mobile, :location, :language, :currency, :role)
    end
end
