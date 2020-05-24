# frozen_string_literal: true

require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get signup_path
    # User数が変わらないかの確認のカウント
    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: '',
        email: 'user@invalid',
        password: 'foo',
        password_confirmation: 'bar'
      } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors'
  end

  test 'valid signup information with account activation' do
    get signup_path
    # User数が変わらないかの確認のカウント 実行前後を比較
    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: 'Example User',
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      } }
    end
    # 配信されたメッセージがきっかり1つであるかどうかを確認
    assert_equal 1, ActionMailer::Base.deliveries.size
    # 対応するアクションのインスタンス変数@userをassignsで使えるようにしている
    user = assigns(:user)
    assert_not user.activated?
    # not activation login
    log_in_as(user)
    assert_not is_logged_in?
    # if activation token is invalid
    get edit_account_activation_path('invalid token', email: user.email)
    assert_not is_logged_in?
    # token is valid but email not activated
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # activation token is valid
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    # assert_not flash.empty?
    # #test_helperのメソッドを呼び出し
    assert is_logged_in?
  end
end
