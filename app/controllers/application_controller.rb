class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  #全コントローラでSessionコントローラを使用可能にする
  include SessionsHelper
end
