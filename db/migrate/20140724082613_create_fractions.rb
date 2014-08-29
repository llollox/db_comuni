class CreateFractions < ActiveRecord::Migration
  def change
    create_table :fractions do |t|
      t.string :name
      t.string :name_encoded
      t.float :latitude
      t.float :longitude
      t.belongs_to :municipality
      t.belongs_to :region

      t.timestamps
    end
    add_index :fractions, :name_encoded
    add_index :fractions, [:name_encoded, :region_id]
  end
end
