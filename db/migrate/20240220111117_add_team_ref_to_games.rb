class AddTeamRefToGames < ActiveRecord::Migration[7.0]
  def change
    add_reference :games, :team, null: true, foreign_key: true
  end
end
