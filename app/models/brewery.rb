class Brewery < ActiveRecord::Base
  include RatingTools

  attr_accessible :name, :year, :active

  scope :active, where(:active => true)
  scope :retired, where(:active => [nil, false])

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

  def self.top(n)

    breweries_with_avg_rating = []
    Brewery.all.each do |b|
      if b.average_rating > 0
        breweries_with_avg_rating.push(b)
      end
    end

    sorted_by_rating_in_desc_order = breweries_with_avg_rating.sort_by{ |b| -b.average_rating }.first(3)

  end


  def to_s
    return self.name + ', ' + self.year.to_s
  end
  def average_rating
    return (self.ratings.inject(0.0) { |result, rating | result + rating.score }) / self.ratings.size
  end


end
