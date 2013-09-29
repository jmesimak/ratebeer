require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:beer1) { FactoryGirl.create :beer, :name => "iso 3", :brewery => brewery }
  let!(:beer2) { FactoryGirl.create :beer, :name => "Karhu", :brewery => brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in 'Pekka', 'foobar1'
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select(beer1.to_s, :from => 'rating[beer_id]')
    fill_in('rating[score]', :with => '15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "lists the ratings and their total number" do
    ratings = create_two_ratings
    visit ratings_path
    expect(page).to have_content "Number of ratings: #{ratings.size}"
    check_page_for_ratings(ratings)
  end

  it "created ratings are shown on the respective user's page" do
    ratings = create_two_ratings
    # user_path does not work
    visit '1#show'
    expect(page).to have_content "has given #{ratings.size} ratings"
    check_page_for_ratings(ratings)
  end

  it "deleted rating is succesfully eradicated from the database" do
    (FactoryGirl.create :rating, :score => 5, :beer => beer1, :user => user)
    visit '1#show'
    click_link 'delete'
    expect(user.ratings.count).to eq(0)
    expect(beer1.ratings.count).to eq(0)
  end

  def check_page_for_ratings(ratings)
    ratings.each do |rating|
      expect(page).to have_content rating
    end
  end

  def create_two_ratings
    ratings = []
    ratings << (FactoryGirl.create :rating, :score => 5, :beer => beer1, :user => user)
    ratings << (FactoryGirl.create :rating2, :score => 6, :beer => beer2, :user => user)
    return ratings
  end
end