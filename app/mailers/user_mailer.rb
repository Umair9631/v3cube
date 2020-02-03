class UserMailer < ApplicationMailer

  def new_signup user
    @user = user

    mail(to: @user.email, subject: "Hello User, Your account has been created.")
  end
end
