class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user
  helper_method :currently_signed_in?
  helper_method :user_is_admin?

  def current_user
    return nil if session[:user_id].nil?
    user = User.where(id: session[:user_id])
    if user.empty?
      reset_session
      return nil
    end
    User.find(session[:user_id])
  end

  def currently_signed_in?(user)
    current_user == user
  end

  def ensure_that_signed_in
    redirect_to signin_path, :notice => 'you should be signed in' if current_user.nil?
  end

  def user_is_admin?
    render text: "You need to be an admin.", status: 503 unless current_user and current_user.admin
  end

end
