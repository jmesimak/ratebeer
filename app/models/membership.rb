class Membership < ActiveRecord::Base
  # attr_accessible :title, :body
  attr_accessible :user_id, :beer_club_id

  belongs_to :user
  belongs_to :beer_club
end
