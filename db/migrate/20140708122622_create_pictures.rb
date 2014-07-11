class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
    	t.attachment :photo
      t.belongs_to :picturable, polymorphic: true
      t.string :photo_url
      t.timestamps
    end
  end
end
