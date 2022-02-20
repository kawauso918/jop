json.array!(@seminars) do |seminar|
  json.extract! seminar, :id, :title
  json.start seminar.starts_at
  json.end seminar.ends_at
end