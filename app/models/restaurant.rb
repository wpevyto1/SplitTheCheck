class Restaurant < ApplicationRecord
  has_many :vote_histories
  has_many :voted_users, through: :vote_histories, source: :users
  has_many :comments, dependent: :destroy
  has_many :favorites

  def vote_count(vote_type)
    vote_histories.where(vote_type: vote_type).count
  end
end
