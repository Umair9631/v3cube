class UserMailer < ApplicationMailer

  def new_signup user
    @user = user

    mail(to: @user.email, subject: "New Sign Up at WorkGrab.")
  end
end
