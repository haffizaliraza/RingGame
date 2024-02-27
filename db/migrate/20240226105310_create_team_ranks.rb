class CreateTeamRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :team_ranks do |t|
      t.references :team, null: false, foreign_key: true
      t.float :success_rate, default: 0.0

      t.timestamps
    end
  end
end
