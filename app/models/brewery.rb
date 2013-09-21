class Brewery < ActiveRecord::Base
  include RatingTools

  attr_accessible :name, :year

  validates_length_of :name, :minimum => 1
  validates_numericality_of :year, { :greater_than_or_equal_to => 1042,
                                     :only_integer => true}
  validate :founding_year_cannot_be_higher_than_current_yer

  has_many :beers
  has_many :ratings, :through => :beers

  def founding_year_cannot_be_higher_than_current_yer
    if year > Date.today.year
      errors.add(:year, "|| You cannot register your to-be brewery in advance. Please found said brewery first and come back when you have something going on.")
    end
  end
  #def average_rating
  #  return (self.ratings.inject(0.0) { |result, rating | result + rating.score }) / self.ratings.size
  #end


end
