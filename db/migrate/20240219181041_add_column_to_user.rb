class AddColumnToUser < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :city, :string, default: ''
    add_column :users, :state, :string, default: ''
    add_column :users, :country, :string, default: ''
    add_column :users, :is_team_admin, :boolean, default: false
    add_reference :users, :team, foreign_key: true, null: true
  end
end
