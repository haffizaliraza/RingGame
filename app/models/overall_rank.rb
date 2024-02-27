class OverallRank < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :user, optional: true
end