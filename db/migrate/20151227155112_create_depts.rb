class CreateDepts < ActiveRecord::Migration
  def change
    create_table :depts do |t|
      t.text :name
      t.text :label		
      t.timestamps null: false
    end
  end
end
