class CreateOverallRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :overall_ranks do |t|
      t.references :team, null: true, foreign_key: true
      t.references :user, null: true, foreign_key: true
      t.float :success_rate, default: 0.0

      t.timestamps
    end
  end
end
