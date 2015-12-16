class CreateAdmins < ActiveRecord::Migration
  def change
    create_table :admins do |t|
      t.integer :adminid
      t.timestamps null: false
    end
  end
end
