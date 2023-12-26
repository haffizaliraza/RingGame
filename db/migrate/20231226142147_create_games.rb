class CreateGames < ActiveRecord::Migration[7.0]
  def change
    create_table :games do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :no_of_shots
      t.string :game_name

      t.timestamps
    end
  end
end
