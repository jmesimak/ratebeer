class Beer < ActiveRecord::Base
  #include Enumerable
  include RatingTools
  attr_accessible :brewery_id, :name, :style_id
  validates_length_of :name, :minimum => 1
  validates_presence_of :style

  belongs_to :brewery
  belongs_to :style

  has_many :ratings, :dependent => :destroy
  has_many :raters, :through => :ratings, :source => :user

  def self.top(n)

    beers_with_average_rating = []
    Beer.all.each do |b|
      if b.average_rating > 0
        beers_with_average_rating.push(b)
      end
    end

    sorted_by_rating_in_desc_order = beers_with_average_rating.sort_by{ |b| -b.average_rating }.first(3)

  end

  def average_rating
    return (self.ratings.inject(0.0) { |result, rating | result + rating.score }) / self.ratings.size
  end

  def to_s
    return self.name + ', ' + self.brewery.name
  end

end
