class Style < ActiveRecord::Base
  attr_accessible :desc, :name

  has_many :beers


  def to_s
    self.name
  end
end
