class CreateJoinTableVideoCallUser < ActiveRecord::Migration[6.1]
  def change
    create_join_table :video_calls, :users do |t|
      t.index [:video_call_id, :user_id]
      t.index [:user_id, :video_call_id]
    end
  end
end
