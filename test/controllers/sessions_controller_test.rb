require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # テスト用のユーザーを取得
  end

  test "should get new" do
    get login_path # sessions_new_url の代わりに適切なルートを使用
    assert_response :success
  end

  test "should create session" do
    post login_path, params: { session: { email: @user.email, password: 'password' } } # POSTリクエストでセッションを作成
    assert_redirected_to root_path # 適切なリダイレクト先に変更する
  end

  test "should destroy session" do
    log_in_as(@user) # ユーザーをログインさせる
    delete logout_path # セッションを破棄
    assert_redirected_to root_path # ログアウト後のリダイレクト先を確認
  end
end
