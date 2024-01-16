require "test_helper"

class SiteSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one) # ユーザーフィクスチャからユーザーを取得
    @article = articles(:one) # 記事フィクスチャから記事を取得
    log_in_as(@user)
    @article.user = @user # 記事にユーザーを割り当てる
    @article.save # 記事を保存
  end

  test "should get edit" do
    get site_settings_edit_url
    assert_response :success
  end

  test "should get update" do
    get site_settings_update_url
    assert_response :success
  end
end
