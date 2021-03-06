class User < ApplicationRecord
  rolify


  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

   def update_logout_details
    self.update_attributes(
      jwt_token: nil
    )
  end

end
