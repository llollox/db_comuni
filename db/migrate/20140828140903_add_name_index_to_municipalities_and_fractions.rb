class AddNameIndexToMunicipalitiesAndFractions < ActiveRecord::Migration
  def change
    add_index :municipalities, [:name, :region_id]
    add_index :fractions, [:name, :region_id]
  end
end
