json.extract! game, :id, :user_id, :no_of_shots, :game_name, :created_at, :updated_at
json.url game_url(game, format: :json)
