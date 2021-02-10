json.extract! video_call, :id, :reason, :status, :created_at, :updated_at
json.url command_url(video_call, format: :json)
