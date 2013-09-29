require 'spec_helper'
include OwnTestHelper

describe "User" do
  let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
    let!(:brewery) { FactoryGirl.create :brewery, :name => "Koff" }
    let!(:beer1) { FactoryGirl.create :beer, :name => "iso 3", :style => "super", :brewery => brewery }
    let!(:beer2) { FactoryGirl.create :beer, :name => "Karhu", :style => "duper", :brewery => brewery }

    it "can sign in with right credentials" do
      sign_in 'Pekka', 'foobar1'
      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to sign in form if wrong credentials given" do
      sign_in 'Pekka', 'noodle'

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', :with => 'Brian')
      fill_in('user_password', :with => 'secret55')
      fill_in('user_password_confirmation', :with => 'secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "shows favorite style and brewery on the user's page" do
      birra = FactoryGirl.create :beer, :name => "iso 3", :style => "super", :brewery => brewery
      reitinki = Rating.create :beer_id => birra.id, :user => user, :score => 10
      sign_in 'Pekka', 'foobar1'
      save_and_open_page
      expect(page).to have_content "Favorite brewery: #{brewery.name}"
      expect(page).to have_content "Favorite style: #{birra.style}"

    end
  end
end