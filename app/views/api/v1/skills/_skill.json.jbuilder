json.data do
  json.array! @skills.each do |s|
    json.id             s.id
    json.skill_icon     s.try(:skill_icon).try(:url)
    json.name           s.name
    json.parent_id      s.parent_id
  end
end
