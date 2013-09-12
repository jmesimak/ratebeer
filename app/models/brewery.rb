class Brewery < ActiveRecord::Base
  include RatingTools

  attr_accessible :name, :year

  has_many :beers
  has_many :ratings, :through => :beers

  #def average_rating
  #  return (self.ratings.inject(0.0) { |result, rating | result + rating.score }) / self.ratings.size
  #end


end
