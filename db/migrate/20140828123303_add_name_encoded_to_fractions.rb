class AddNameEncodedToFractions < ActiveRecord::Migration
  def change
    add_column :fractions, :name_encoded, :string
    add_index :fractions, :name_encoded
  end
end
