class CreateDbComuniPictures < ActiveRecord::Migration
  def change
    create_table :db_comuni_pictures do |t|
      t.attachment :photo
      t.belongs_to :picturable, polymorphic: true

      t.timestamps
    end
    add_index :db_comuni_pictures, [:picturable_id, :picturable_type]
  end
end
