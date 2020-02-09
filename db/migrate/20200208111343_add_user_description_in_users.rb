class AddUserDescriptionInUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :service_description, :string
  end
end
