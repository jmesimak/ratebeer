class BeerClub < ActiveRecord::Base
  attr_accessible :city, :founded, :name

  has_many :memberships
  has_many :members, through: :memberships, source: :user

  def confirmed_members
      memberships.where(:confirmed => true)
  end

  def unconfirmed_members
      memberships.where(:confirmed => [false,nil])
  end

  def to_s
    return self.name
  end

end
