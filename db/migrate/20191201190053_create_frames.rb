class CreateFrames < ActiveRecord::Migration[5.1]
  def change
    create_table :frames do |t|
      t.references :game
      t.references :player
      t.integer :knocked_pins1
      t.integer :knocked_pins2
      t.integer :score

      t.timestamps
    end
  end
end
