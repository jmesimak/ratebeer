class Membership < ActiveRecord::Base
  attr_accessible :user_id, :beer_club_id, :confirmed

  scope :confirmed, where(:confirmed => true)
  scope :unconfirmed, where(:unconfirmed => [nil, false])

  belongs_to :user
  belongs_to :beer_club

  def is_confirmed?
    return self.confirmed
  end

  def confirm_membership
    self.confirmed = true
    self.save
  end
end