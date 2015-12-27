class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.integer :dept_id
      t.string :number
      t.string :name
      t.string :prof
      t.integer :credits

      t.timestamps null: false
    end
  end
end
