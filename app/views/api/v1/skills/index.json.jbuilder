json.success true
json.msg     'Skills List'

json.data do
  json.array! @skills.each do |s|
    json.id         s.id
    json.name       s.name
    json.parent_id  s.parent_id
  end
end
