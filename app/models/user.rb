class User < ActiveRecord::Base
  include RatingTools
  include Enumerable
  attr_accessible :username, :password, :password_confirmation
  has_secure_password

  validates_uniqueness_of :username
  validates_length_of :username, :minimum => 3, :maximum => 15, :allow_blank => false
  validates_length_of :password, :minimum => 4
  validates :password, :format => {:with => /^(?=.*[a-zA-Z])(?=.*[0-9]).{4,}$/, message: "must be at least 4 characters and include one number and one letter."}

  has_many :ratings, dependent: :destroy, :include => [ :beer ]
  has_many :beers, through: :ratings, include: [:brewery, :style]
  has_many :memberships
  has_many :clubmanships, through: :memberships, source: :beer_club

  def favorite_beer
    return nil if ratings.empty?
    ratings.order('score DESC').first.beer
  end

  def favorite_style
    favorite :style
  end

  def name
    return self.username
  end

  def favorite_brewery
    favorite :brewery
  end

  def self.top_raters(n)
    User.all.sort_by { |u| u.ratings.count }.first(n)
  end

  def member_of(club)
    m = Membership.where(:user_id => self.id, :beer_club_id => club.id).first.confirmed
    if self.clubmanships.include? club
      if m
        return true
      end
    end
    return false
  end

  def confirmed_memberships
    Membership.where(:confirmed => true)
  end

  def pending_memberships
    Membership.where(:confirmed => [nil, false])
  end

  private

  def favorite property
    return nil if beers.empty?
    ratings_with_property = ratings_beers.group_by{|rating| rating.beer.send property}
    ratings_with_property.max_by{|_, rs| rs.map(&:score).inject(0.0, :+) / rs.size}.first
  end
end
