module RatingTools
  def average_rating
    return (self.ratings.inject(0.0) { |result, rating | result + rating.score }) / self.ratings.size
  end
end