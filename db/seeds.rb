b1 = Brewery.create :name => "Koff", :year => 1897, :active = true
b2 = Brewery.create :name => "Malmgard", :year => 2001, :active = true
b3 = Brewery.create :name => "Weihenstephaner", :year => 1042, :active = true
b4 = Brewery.create :name => "Wolfgang Amadeus Mozart", :year => 943, :active = true

s1 = Style.create name: "Good bier", desc: "Totally irrelevant"

b1.beers.create :name => "Iso 3", style_id: s1.id
b1.beers.create :name => "Karhu", style_id: s1.id
b1.beers.create :name => "Tuplahumala", style_id: s1.id
b2.beers.create :name => "Huvila Pale Ale", style_id: s1.id
b2.beers.create :name => "X Porter", style_id: s1.id
b3.beers.create :name => "Hefezeizen", style_id: s1.id
b3.beers.create :name => "Helles", style_id: s1.id