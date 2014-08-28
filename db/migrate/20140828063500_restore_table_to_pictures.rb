class RestoreTableToPictures < ActiveRecord::Migration
  def change
    rename_table :db_comuni_pictures, :pictures
  end
end
