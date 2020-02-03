class AddColumnsInUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :profile_url,  :string
    add_column :users, :first_name,   :string
    add_column :users, :last_name,    :string
    add_column :users, :country,      :string
    add_column :users, :mobile,       :string
    add_column :users, :location,     :string
    add_column :users, :language,     :string
    add_column :users, :currency,     :string
  end
end
