class RemoveUrlFromPictures < ActiveRecord::Migration
  def change
  	remove_column :pictures, :photo_url
  end
end
