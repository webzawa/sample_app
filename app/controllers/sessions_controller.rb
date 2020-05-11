class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    #authenticateメソッドはhas_secure_passwordから、認証失敗の際falseを返す
    if user && user.authenticate(params[:session][:password])
      #login & redirect to user_page
      #log_inメソッドはHelperから呼び出し
      log_in user
      #redirect_to の引数にuserを与えているが、Rails側で "user_url(user)"と解釈してくれている
      redirect_to user
    else
      #view error message
      # flash[:danger] = 'Invalid email/password combination' # 本当は正しくない
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
    
  end

  def destroy
    #sessions_helperのメソッド呼び出し
    log_out
    redirect_to root_url
  end
end
