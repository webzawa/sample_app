module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    if session[:user_id]
    #   @current_user = User.find_by(id: session[:user_id])
    # else
    #   @current_user

      #短縮記法
      @current_user ||= User.find_by(id: session[:user_id])
    end
  end

  def logged_in?
    #current_userがnilでなければログインしている状態を表す
    !current_user.nil?
  end

  def log_out
    session.delete(:user_id)
    @current_user = nil
  end

end
