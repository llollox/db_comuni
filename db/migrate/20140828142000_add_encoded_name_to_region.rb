class AddEncodedNameToRegion < ActiveRecord::Migration
  def change
  	add_column :regions, :name_encoded, :string
    add_index :regions, :name_encoded
  end
end
