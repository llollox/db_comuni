class AddIndexToNameEncoded < ActiveRecord::Migration
  def change
    add_index :municipalities, :name_encoded
  end
end
