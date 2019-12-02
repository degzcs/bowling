class AddDefaults < ActiveRecord::Migration[5.1]
  def change
    change_column_default :frames, :knocked_pins1, from: nil, to: 0
    change_column_default :frames, :knocked_pins2, from: nil, to: 0
    change_column_default :frames, :number, from: nil, to: 0
    change_column_default :frames, :score, from: nil, to: 0
    change_column_default :games, :total_score, from: nil, to: 0
  end
end

