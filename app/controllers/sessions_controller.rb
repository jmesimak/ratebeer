class SessionsController < ApplicationController
  def new
    # renderöi kirjautumissivun
  end

  def create
    # haetaan usernamea vastaava käyttäjä tietokannasta
    user = User.find_by_username params[:username]
    # talletetaan sessioon kirjautuneen käyttäjän id (jos käyttäjä on olemassa)
    session[:user_id] = user.id if not user.nil?
    redirect_to user_path(user)
  end

  def destroy
    # nollataan sessio
    session[:user_id] = nil
    # uudelleenohjataan sovellus pääsivulle
    redirect_to :root
  end
end