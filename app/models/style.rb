class Style < ActiveRecord::Base
  attr_accessible :desc, :name

  has_many :beers
  has_many :ratings, :through => :beers

  def self.top(n)
    styles_with_average_rating = []
    Style.all.each do |s|
      if s.average_rating > 0
        styles_with_average_rating.push(s)
      end
    end
    sorted_by_rating_in_desc_order = styles_with_average_rating.sort_by{ |b| -b.average_rating }.first(3)
  end

  def average_rating
    return (self.ratings.inject(0.0) { |result, rating | result + rating.score }) / self.ratings.size
  end

  def to_s
    self.name
  end
end
