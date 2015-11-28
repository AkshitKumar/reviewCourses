class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.string :number
      t.string :prof
      t.integer :credits

      t.timestamps null: false
    end
  end
end
