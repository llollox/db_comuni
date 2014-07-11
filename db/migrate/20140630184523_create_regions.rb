class CreateRegions < ActiveRecord::Migration
  def change
    create_table :regions do |t|
      t.string :name
      t.integer :capital_id
      t.string :president
      t.integer :population
      t.float :density
      t.float :surface
      t.string :abbreviation
      t.string :email
      t.string :website

      t.timestamps
    end
  end
end
