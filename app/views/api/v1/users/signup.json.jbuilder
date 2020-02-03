json.success true
json.msg     'User created successfully.'

json.data do
  json.user do
    json.id                   @user.id
    json.name                 @user.name
    json.email                @user.email
  end
end
