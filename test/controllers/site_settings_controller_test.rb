require "test_helper"

class SiteSettingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    log_in_as(@user)
  end

  test "should get edit" do
    get edit_site_settings_url
    assert_response :success
  end

  test "should update site setting" do
    patch site_settings_url, params: { site_setting: { site_title: '新しいタイトル', site_description: '新しい説明', site_meta_description: '新しいメタ説明' } }
    assert_redirected_to root_url
  end
end
