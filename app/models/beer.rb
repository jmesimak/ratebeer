class Beer < ActiveRecord::Base
  include Enumerable
  include RatingTools
  attr_accessible :brewery_id, :name, :style

  validates_length_of :name, :minimum => 1
  validates_presence_of :style

  belongs_to :brewery

  has_many :ratings, :dependent => :destroy
  has_many :raters, :through => :ratings, :source => :user

  #def average_rating_typical
  #  allRatings = self.ratings
  #  total = 0.0
  #  allRatings.each do |rating|
  #    total+=rating.score
  #  end
  #  return total/allRatings.size
  #end

  def average_rating
    return (self.ratings.inject(0.0) { |result, rating | result + rating.score }) / self.ratings.size
  end

  def to_s
    return self.name + ', ' + self.brewery.name
  end

end
