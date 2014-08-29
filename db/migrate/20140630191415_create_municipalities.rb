class CreateMunicipalities < ActiveRecord::Migration
  def change
    create_table :municipalities do |t|
      t.belongs_to :province
      t.belongs_to :region
      t.string :name
      t.string :name_encoded
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
    add_index :municipalities, :name_encoded
    add_index :municipalities, [:name_encoded, :region_id]
  end
end
