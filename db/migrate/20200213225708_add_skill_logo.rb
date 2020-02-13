class AddSkillLogo < ActiveRecord::Migration[5.2]
  def change
    add_column :skills, :skill_icon, :string 
  end
end
