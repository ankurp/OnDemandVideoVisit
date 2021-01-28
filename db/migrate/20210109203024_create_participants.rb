class CreateParticipants < ActiveRecord::Migration[6.1]
  def change
    create_table :participants do |t|
      t.references :user, null: false, foreign_key: true
      t.references :video_call, null: false, foreign_key: true

      t.timestamps
    end
  end
end
