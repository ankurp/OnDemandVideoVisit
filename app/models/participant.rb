class Participant < ApplicationRecord
  belongs_to :video_call
  belongs_to :user

  broadcasts_to ->(participant) { [participant.user, :video_calls] }, target: "video_calls"
end
