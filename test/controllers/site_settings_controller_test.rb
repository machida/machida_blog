require "test_helper"

class SiteSettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get site_settings_edit_url
    assert_response :success
  end

  test "should get update" do
    get site_settings_update_url
    assert_response :success
  end
end
