class CreateCaps < ActiveRecord::Migration
  def change
    create_table :caps do |t|
      t.string :number
      t.belongs_to :municipality

      t.timestamps
    end
  end
end
