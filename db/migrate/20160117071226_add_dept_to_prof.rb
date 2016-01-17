class AddDeptToProf < ActiveRecord::Migration
  def change
  	drop_table :profs
  	create_table :profs do |t|
  		t.string :name	
      	t.string :dept
      	t.timestamps null: false
    end
  end
end