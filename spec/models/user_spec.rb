require 'spec_helper'

# Helper methods
def create_beer_with_rating(score,  user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, :score => score,  :beer => beer, :user => user)
  beer
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
      beer1 = FactoryGirl.create(:beer)
      beer2 = FactoryGirl.create(:beer)
      beer3 = FactoryGirl.create(:beer)
      rating1 = FactoryGirl.create(:rating, :beer => beer1, :user => user)
      rating2 = FactoryGirl.create(:rating, :score => 25,  :beer => beer2, :user => user)
      rating3 = FactoryGirl.create(:rating, :score => 9, :beer => beer3, :user => user)

      expect(user.favorite_beer).to eq(beer2)
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
