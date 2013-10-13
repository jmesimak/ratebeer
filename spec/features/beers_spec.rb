require 'spec_helper'
include OwnTestHelper

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
  let!(:style) { FactoryGirl.create :style }
 # let!(:user) { FactoryGirl.create :user }

  #before :each do
  #  sign_in 'Pekka', 'foobar1'
  #end

  it "when a new beer is created, it is added to the database" do
    user = User.create :username => "jaska", :password => "eki123", :password_confirmation => "eki123"
    visit signin_path
    fill_in('username', :with => 'jaska')
    fill_in('password', :with => 'eki123')
    click_button('Log in')
    visit new_beer_path

    fill_in('beer[name]', with: 'olut')
    save_and_open_page
    click_button('Create Beer')

    expect(Beer.all.count).to eq(1)
    expect(page).to have_content 'olut'
  end

end