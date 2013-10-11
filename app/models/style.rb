class Style < ActiveRecord::Base
  attr_accessible :desc, :name

  has_many :beers

end
