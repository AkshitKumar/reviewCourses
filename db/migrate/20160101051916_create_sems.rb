class CreateSems < ActiveRecord::Migration
  def change
    create_table :sems do |t|
      t.string :label	
      t.timestamps null: false
    end
  end
end
