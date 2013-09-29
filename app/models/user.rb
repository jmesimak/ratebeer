class User < ActiveRecord::Base
  include RatingTools
  include Enumerable
  attr_accessible :username, :password, :password_confirmation
  has_secure_password

  validates_uniqueness_of :username
  validates_length_of :username, :minimum => 3, :maximum => 15, :allow_blank => false
  validates_length_of :password, :minimum => 4
  validates :password, :format => {:with => /^(?=.*[a-zA-Z])(?=.*[0-9]).{4,}$/, message: "must be at least 4 characters and include one number and one letter."}

  has_many :ratings, dependent: :destroy
  has_many :beers, :through => :ratings
  has_many :memberships
  has_many :clubmanships, through: :memberships, source: :beer_club

  def favorite_beer
    return nil if ratings.empty?
    ratings.sort_by{ |r| r.score }.last.beer
  end

  def favorite_style
    return nil if ratings.empty?
     style_ratings = ratings.group_by { |rating| rating.beer.style}
     style_rating = style_ratings.each_pair{|style, score| style_ratings[style] = score.sum(&:score) / score.size}
     return style_ratings.sort_by{ |style, score| score}.last[0]
  end

  def favorite_brewery
    return nil if ratings.empty?
    brewery_ratings = ratings.group_by { |rating| rating.beer.brewery}
    style_rating = brewery_ratings.each_pair{|brewery, score| brewery_ratings[brewery] = score.sum(&:score) / score.size}
    return brewery_ratings.sort_by{ |brewery, score| score}.last[0]
  end
end
