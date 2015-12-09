class CreateOauths < ActiveRecord::Migration
  def change
    create_table :oauths do |t|
      t.string :only
      t.string :create

      t.timestamps null: false
    end
  end
end
