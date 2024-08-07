class CreateRanks < ActiveRecord::Migration[7.0]
  def change
    create_table :ranks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :team, null: true, foreign_key: true
      t.float :success_rate, default: 0.0

      t.timestamps
    end
  end
end
