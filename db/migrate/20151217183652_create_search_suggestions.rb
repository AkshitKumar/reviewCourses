class CreateSearchSuggestions < ActiveRecord::Migration
  def change
    create_table :search_suggestions do |t|
      t.string :term
      t.integer :course_id
      t.string :term_type
      t.integer :popularity

      t.timestamps null: false
    end
  end
end
