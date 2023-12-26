class CreateShorts < ActiveRecord::Migration[7.0]
  def change
    create_table :shorts do |t|
      t.references :game, null: false, foreign_key: true
      t.boolean :result

      t.timestamps
    end
  end
end
