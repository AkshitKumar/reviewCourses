class CreateNotifications < ActiveRecord::Migration
  def up
    create_table :notifications do |t|
      t.integer :user_id
      t.integer :owner_id
      t.integer :course_id
      t.string :notif_type
      t.string :action
      t.boolean :read
      t.timestamps null: false
    end
  end

  def down
  	drop_table :notifications
  end
end
