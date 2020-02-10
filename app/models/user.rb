class User < ApplicationRecord
  rolify

  mount_uploader :profile_url, PictureUploader

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   def update_logout_details
    self.update_attributes(
      last_login: Time.now,
      jwt_token: nil,
    )
  end

end
