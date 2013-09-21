class Rating < ActiveRecord::Base
  attr_accessible :beer_id, :score


  belongs_to :beer
  belongs_to :user
  validates_presence_of :beer, :beer_id
  validates_numericality_of :score, { :greater_than_or_equal_to => 1,
                                      :less_than_or_equal_to => 50,
                                      :only_integer => true }


  def to_s
    return self.beer.name + " " + self.score.to_s
  end


end
