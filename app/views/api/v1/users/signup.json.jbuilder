json.success true
json.msg     'User created successfully.'

json.data do
  json.user do
    json.id                   @user.id
    json.username             @user.username
    json.email                @user.email
  end
end
