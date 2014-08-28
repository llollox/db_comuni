class AddEncodedNameToMunicipality < ActiveRecord::Migration
  def change
    add_column :municipalities, :name_encoded, :string
  end
end
