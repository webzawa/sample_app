# frozen_string_literal: true

class AccountActivationsController < ApplicationController
  # before_create :create_activation_digest

  # private

  # def create_activation_digest
  #   # 有効トークンとDIGESTを作成及び代入する
  # end

  def edit
    user = User.find_by(email: params[:email])
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      # user.update_attribute(:activated, true)
      # user.update_attribute(:activated_at, Time.zone.now)
      # userModelのdefにリファクタリング
      user.activate
      log_in user
      flash[:success] = 'Account activated!'
      redirect_to user
    else
      flash[:danger] = 'Invalid activation link'
      redirect_to root_url
    end
  end
end
