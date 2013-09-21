class User < ActiveRecord::Base
  include RatingTools
  attr_accessible :username, :password, :password_confirmation
  has_secure_password

  validates_uniqueness_of :username
  validates_length_of :password, :minimum => 4



  has_many :ratings, dependent: :destroy
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :clubmanships, through: :memberships, source: :beer_club
end
