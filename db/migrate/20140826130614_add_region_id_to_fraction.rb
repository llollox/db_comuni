class AddRegionIdToFraction < ActiveRecord::Migration
  def change
    add_column :fractions, :region_id, :integer
  end
end
