json.extract! answer, :id, :body, :question_id, :user_id, :best

json.files answer.files do |file|
  json.file_name file.filename
  json.file_url url_for(file)
end

json.links answer.links do |link|
  json.name link.name
  json.url link.url
end
