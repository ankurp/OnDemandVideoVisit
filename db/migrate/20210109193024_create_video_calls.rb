class CreateVideoCalls < ActiveRecord::Migration[6.1]
  def change
    create_table :video_calls do |t|
      t.string :reason
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
