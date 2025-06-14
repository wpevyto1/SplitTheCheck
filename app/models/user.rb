class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :vote_histories
  has_many :voted_restaurants, through: :vote_histories, source: :restaurant
  has_many :comments, dependent: :destroy
  has_many :favorites
  has_many :favorite_restaurants, through: :favorites, source: :restaurant
end
