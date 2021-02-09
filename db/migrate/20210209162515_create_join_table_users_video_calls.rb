class CreateJoinTableUsersVideoCalls < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :video_calls do |t|
      # t.index [:user_id, :video_call_id]
      # t.index [:video_call_id, :user_id]
    end
  end
end
