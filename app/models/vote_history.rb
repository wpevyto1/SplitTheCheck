class VoteHistory < ApplicationRecord
  belongs_to :user
  belongs_to :restaurant
  validates :vote_type, inclusion: { in: ['will_split', 'wont_split']}
end
