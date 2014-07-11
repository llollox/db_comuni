class RemoveCapitalFromRegion < ActiveRecord::Migration
  def change
  	remove_column :provinces, :capital_id
  	remove_column :municipalities, :capital_id
  	remove_column :municipalities, :region_id
  end
end
