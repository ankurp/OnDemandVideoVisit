require "twilio-ruby"

class VideoCall < ApplicationRecord
  include Hashid::Rails

  enum status: [:not_started, :in_progress, :completed]

  scope :completed, -> { where(status: :completed) }
  scope :not_completed, -> { where(status: [:not_started, :in_progress]) }

  @@account_sid = Rails.application.credentials[:twilio][:account_sid]
  @@auth_token = Rails.application.credentials[:twilio][:auth_token]
  @@api_key_sid = Rails.application.credentials[:twilio][:sid]
  @@api_key_secret = Rails.application.credentials[:twilio][:secret]

  # after_create :create_twilio_room

  has_and_belongs_to_many :users

  after_create_commit  -> { self.users.each { |u| broadcast_action_later_to [u, :video_calls], action: :prepend } }
  after_update_commit  -> { self.users.each { |u| broadcast_replace_later_to [u, :video_calls] } }
  before_destroy -> { self.users.each { |u| broadcast_remove_to [u, :video_calls] } }
  
  after_create_commit ->(video_call) { broadcast_append_to [:video_calls], partial: "video_calls/video_call_row" }
  after_update_commit ->(video_call) { broadcast_replace_to [:video_calls], partial: "video_calls/video_call_row" }
  after_destroy_commit ->(video_call) { broadcast_remove_to [:video_calls] }

  def client
    @client ||= Twilio::REST::Client.new(@@account_sid, @@auth_token)
  end

  def room_name
    "#{hashid}#{created_at.hash}"
  end

  def create_twilio_room
    client.video.rooms.create(unique_name: room_name, type: "peer-to-peer")
  end

  def access_token(user)
    token = Twilio::JWT::AccessToken.new @@account_sid, @@api_key_sid, @@api_key_secret,
      identity: user.email

    grant = Twilio::JWT::AccessToken::VideoGrant.new
    grant.room = room_name
    token.add_grant grant

    token.to_jwt
  end

  def html_data_attributes(current_user)
    {
      controller: "videocall",
      "videocall-access-token-value": access_token(current_user),
      "videocall-room-name-value": room_name
    }
  end
end
