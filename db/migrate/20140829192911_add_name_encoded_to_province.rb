class AddNameEncodedToProvince < ActiveRecord::Migration
  def change
    add_column :provinces, :name_encoded, :string
    add_index :provinces, :name_encoded
    add_index :provinces, [:name_encoded, :region_id]
  end
end
