require 'spec_helper'

# Helper methods
def create_beer_with_rating(score,  user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating score, user
  end
end

# Tests
describe User do
  it "has the username set correctly" do
    user = User.new :username => "Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a proper password" do
    user = User.create :username => "Pekka"

    expect(user.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }

    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end

    it "is the only rated if only one rating" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, :beer => beer, :user => user)

      expect(user.favorite_beer).to eq(beer)
    end

    it "is the one with highest rating if several rated" do
      create_beer_with_rating 10, user
      best = create_beer_with_rating 25, user
      create_beer_with_rating 7, user

      expect(user.favorite_beer).to eq(best)
    end
  end

  describe "favorite brewery" do
    let(:user) {FactoryGirl.create(:user)}
    it "has method for favorite brewery" do
      user.should respond_to :favorite_brewery
    end

    it "is the correct brewery with many beers, breweries and ratings" do
      brw = FactoryGirl.create(:brewery)
      brw2 = FactoryGirl.create(:brewery2)
      bier = FactoryGirl.create(:beer, :brewery => brw)
      bier2 = FactoryGirl.create(:beer2, :brewery => brw2)
      FactoryGirl.create(:rating, :beer => bier, :user => user)
      FactoryGirl.create(:rating2, :beer => bier, :user => user)
      FactoryGirl.create(:rating3, :beer => bier2, :user => user)

      expect(user.favorite_brewery).to eq(brw2)
    end
  end

  describe "favorite style" do
    let(:user) {FactoryGirl.create(:user)}

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end

    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end

    it "is the only rated if only one rating associated with a style" do
      beer = FactoryGirl.create(:beer)
      rating = FactoryGirl.create(:rating, :beer => beer, :user => user)

      expect(user.favorite_style).to eq(beer.style)
    end

    it "is the one with highest rating average if several rated" do
      bier = Beer.create :name => "bank", :styles => "buster"
      bier_two = Beer.create :name => "bonk", :styles => "buster"
      bier_tri = Beer.create :name => "badonkadonk", :styles => "rooster"

      bier.ratings << (Rating.create :score => 50)
      bier_two.ratings << (Rating.create :score => 50)
      bier_tri.ratings << (Rating.create :score => 51)

      user.ratings << bier.ratings.first
      user.ratings << bier_two.ratings.first
      user.ratings << bier_tri.ratings.first

      expect(user.favorite_style).to eq(bier_tri.style)

    end
  end

  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user)}

    it "is saved" do
      expect(user.valid?).to be(true)
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      birra = FactoryGirl.create(:beer)
      birra.ratings << FactoryGirl.create(:rating)
      birra.ratings << FactoryGirl.create(:rating2)

      user.ratings << birra.ratings.first
      user.ratings << birra.ratings.last

      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end

  it "with a rather bad password consisting of only letters" do
    urkki = User.create :username => "Batman", :password => "robinrobin", :password_confirmation => "robinrobin"

    expect(urkki.valid?).to be(false)
    expect(User.count).to eq(0)
  end

  it "with too short password" do
    napoleon = User.create :username => "Bonaparte", :password => "as1", :password_confirmation => "as1"
    expect(napoleon.valid?).to be(false)
    expect(User.count).to eq(0)
  end
end
