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

  def favorite_brewery
    favorite :brewery
  end

  def rated_breweries
    ratings.map{ |r|r.beer.brewery }.uniq
  end

  def brewery_rating_average(brewery)
    ratings_of_brewery = ratings.select{ |r|r.beer.brewery==brewery }
    return 0 if ratings_of_brewery.empty?
    ratings_of_brewery.inject(0.0){ |sum ,r| sum+r.score } / ratings_of_brewery.count
  end

  def favorite_style
    favorite :styles
  end

  def rated_styles
    ratings.map{ |r|r.beer.style }.uniq
  end

  def rated category
    ratings.map{ |r| r.beer.send(category) }.uniq
  end

  def rating_average(category, item)
    ratings_of_item = ratings.select{ |r|r.beer.send(category)==item }
    return 0 if ratings_of_item.empty?
    ratings_of_item.inject(0.0){ |sum ,r| sum+r.score } / ratings_of_item.count
  end

  def favorite(category)
    return nil if ratings.empty?
    rating_pairs = rated(category).inject([]) do |pairs, item|
      pairs << [item, rating_average(category, item)]
    end
    rating_pairs.sort_by { |s| s.last }.last.first
  end

  def style_rating_average(style)
    ratings_of_style = ratings.select{ |r| r.beer.style==style }
    return 0 if ratings_of_style.empty?
    ratings_of_style .inject(0.0){ |sum ,r| sum+r.score } / ratings_of_style.count
  end
end
