json.extract! video_call, :id, :name, :created_at, :updated_at
json.url video_call_url(video_call, format: :json)
