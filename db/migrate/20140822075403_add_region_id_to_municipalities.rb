class AddRegionIdToMunicipalities < ActiveRecord::Migration
  def change
    add_column :municipalities, :region_id, :integer
  end
end
