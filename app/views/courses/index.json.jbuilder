json.array!(@courses) do |course|
  json.extract! course, :id, :name, :number, :prof, :credits
  json.url course_url(course, format: :json)
end
