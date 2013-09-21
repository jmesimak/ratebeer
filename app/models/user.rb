class User < ActiveRecord::Base
  include RatingTools
  attr_accessible :username, :password, :password_confirmation
  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :clubmanships, through: :memberships, source: :beer_club
end
