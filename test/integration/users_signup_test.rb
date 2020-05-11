require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signup information" do
    get signup_path
    #User数が変わらないかの確認のカウント
    assert_no_difference 'User.count' do
      post users_path, params:{user:{
        name: "",
        email: "user@invalid",
        password: "foo",
        password_confirmation: "bar"
      }}
    end
    assert_template 'users/new'
    # assert_select 'div#<CSS id for error explanation>'
    # assert_select 'div.<CSS class for field with error>'
  end

  test "valid signup information" do
    get signup_path
    #User数が変わらないかの確認のカウント 実行前後を比較
    assert_difference 'User.count' do
      post users_path, params:{user:{
        name: "Example User",
        email: "user@example.com",
        password: "password",
        password_confirmation: "password"
      }}
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    #test_helperのメソッドを呼び出し
    assert is_logged_in?
  end

end