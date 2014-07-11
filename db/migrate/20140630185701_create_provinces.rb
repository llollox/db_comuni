class CreateProvinces < ActiveRecord::Migration
  def change
    create_table :provinces do |t|
    	t.belongs_to :region
      t.string :name
      t.string :president
      t.integer :capital_id
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
