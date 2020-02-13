class Skill < ApplicationRecord

  mount_uploader :skill_icon, PictureUploader
  ## Associations
  # has_many :users, through: :user_skills
  # has_many :user_skills

  #self referential
  belongs_to :parent, class_name: "Skill", foreign_key: "parent_id", optional: true
  has_many :children, class_name: "Skill", foreign_key: "parent_id"

  scope :parent_skills, -> { where(parent_id: 0) }
end
