class ChangeIndexToMunicipalityAndFractions < ActiveRecord::Migration
  def change
    remove_index :municipalities, [:name, :region_id]
    remove_index :fractions, [:name, :region_id]

    add_index :municipalities, [:name_encoded, :region_id]
    add_index :fractions, [:name_encoded, :region_id]
  end
end
