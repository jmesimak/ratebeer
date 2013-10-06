require 'spec_helper'

describe "BeermappingAPI" do
  it "When HTTP GET returns one entry, it is parsed and returned" do

    s = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>13307</id><name>O'Connell's Irish Bar</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=13307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=13307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=13307&amp;d=1&amp;type=norm</blogmap><street>Rautatienkatu 24</street><city>Tampere</city><state></state><zip>33100</zip><country>Finland</country><phone>35832227032</phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*/).to_return(:body => s, :headers => { 'Content-Type' => "text/xml" })

    places = BeermappingAPI.places_in("tampere")

    expect(places.size).to eq(1)
    place = places.first
    expect(place.name).to eq("O'Connell's Irish Bar")
    expect(place.street).to eq("Rautatienkatu 24")
  end

  it "when more than one are returned" do
    s = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id>11307</id><name>Beer Mania</name><status>Beer Bar</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=11307</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=11307&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=11307&amp;d=1&amp;type=norm</blogmap><street>NanSanlitun Road, 16</street><city>Beijing</city><state>Beijing</state><zip>100020</zip><country>China</country><phone>+86 10 6585 0786</phone><overall>0</overall><imagecount>0</imagecount></location><location><id>15604</id><name>Slow Boat Brewery</name><status>Brewery</status><reviewlink>http://beermapping.com/maps/reviews/reviews.php?locid=15604</reviewlink><proxylink>http://beermapping.com/maps/proxymaps.php?locid=15604&amp;d=5</proxylink><blogmap>http://beermapping.com/maps/blogproxy.php?locid=15604&amp;d=1&amp;type=norm</blogmap><street>Changping</street><city>beijing</city><state>Beijing</state><zip>100027</zip><country>Canada</country><phone></phone><overall>0</overall><imagecount>0</imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*/).to_return(:body => s, :headers => { 'Content-Type' => "text/xml" })

    places = BeermappingAPI.places_in("Beijing")

    expect(places.size).to eq(2)
    place = places.first
    expect(place.name).to eq("Beer Mania")
    place2 = places.last
    expect(place2.name).to eq("Slow Boat Brewery")
  end

  it "when none are returned" do
    s = <<-END_OF_STRING
<?xml version='1.0' encoding='utf-8' ?><bmp_locations><location><id></id><name></name><status></status><reviewlink></reviewlink><proxylink></proxylink><blogmap></blogmap><street></street><city></city><state></state><zip></zip><country></country><phone></phone><overall></overall><imagecount></imagecount></location></bmp_locations>
    END_OF_STRING

    stub_request(:get, /.*/).to_return(:body => s, :headers => { 'Content-Type' => "text/xml" })
    places = BeermappingAPI.places_in("Spolrororor")
    expect(places.size).to eq(0)
  end

end