class CreateFractions < ActiveRecord::Migration
  def change
    create_table :fractions do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.belongs_to :municipality

      t.timestamps
    end
  end
end
