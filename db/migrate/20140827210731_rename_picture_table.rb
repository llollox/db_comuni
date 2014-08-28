class RenamePictureTable < ActiveRecord::Migration
  def change
    rename_table :pictures, :db_comuni_pictures
  end
end
