# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Role.delete_all

['super_admin', 'admin', 'service_user', 'service_provider'].each do |role_name|
  Role.create! name: role_name
end
puts "Roles created successfully."


admin = User.create(name: "Muhammad Umair", email: "superadmin@v3cube.com", password: '123123123')
admin.add_role :super_admin

puts "Super admin created successfully."
