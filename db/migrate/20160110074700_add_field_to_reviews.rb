class AddFieldToReviews < ActiveRecord::Migration
  def change
  	add_column :reviews , :grading , :text
  	add_column :reviews , :learning , :text
  	add_column :reviews , :apply , :text
  	add_column :reviews , :prerequisites , :text
  	add_column :reviews , :usefulforcareer , :text
  	remove_column :reviews , :comment
  end
end
