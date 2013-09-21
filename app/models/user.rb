class User < ActiveRecord::Base
  include RatingTools
  attr_accessible :username

  has_many :ratings
  has_many :beers, :through => :ratings
end
