json.success true
json.msg     "User assigned authentication token"

json.data do
  json.id               @user.id
  json.username         @user.username
  json.email            @user.email
  json.jwt_token        @user.jwt_token
  json.profile_url      @user.profile_url.url
end
