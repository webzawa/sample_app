# frozen_string_literal: true

module SessionsHelper
  def log_in(user)
    session[:user_id] = user.id
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def current_user?(user)
    user == current_user
  end

  def current_user
    # if session[:user_id]
    if (user_id = session[:user_id])
      #   @current_user = User.find_by(id: session[:user_id])
      # else
      #   @current_user
      # 短縮記法
      @current_user ||= User.find_by(id: user_id)
    # elsif cookies.signed[:user_id]
    elsif (user_id = cookies.signed[:user_id])
      # raise #testがうまく行けば、ここがテストされていないことがわかる
      # user = User.find_by(id: cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      # if user&.authenticated?(cookies[:remember_token])
      if user&.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def logged_in?
    # current_userがnilでなければログインしている状態を表す
    !current_user.nil?
  end

  # 永続セッションの破棄
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # 記憶したURLかデフォルト値にリダイレクト
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end

  # アクセスしたURLを記憶する ※GETリクエスト時のみ
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
