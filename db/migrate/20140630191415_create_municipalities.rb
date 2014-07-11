class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.belongs_to :province
      t.belongs_to :region
      t.string :name
      t.integer :capital_id
      t.string :president
      t.integer :population
      t.float :density
      t.float :surface
      t.string :istat_code
      t.string :cadastral_code
      t.string :telephone_prefix
      t.string :email
      t.string :website
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
