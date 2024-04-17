class AddMaxStreakToRanks < ActiveRecord::Migration[7.0]
  def change
    add_column :ranks, :max_streak, :integer, default: 0
  end
end
