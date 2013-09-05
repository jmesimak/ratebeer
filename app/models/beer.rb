class Beer < ActiveRecord::Base
  attr_accessible :brewery_id, :name, :style

  belongs_to :brewery

  has_many :ratings

  def average_rating
    allRatings = self.ratings
    total = 0.0
    allRatings.each do |rating|
      total+=rating.score
    end
    return total/allRatings.size
  end

end
