# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

User.find_or_create_by(email: 'user1@example.com') do |user|
  user.account_id = 'machida'
  user.password = 'password'
  user.password_confirmation = 'password'
end

# SiteSetting の作成
site_setting = SiteSetting.first_or_initialize
site_setting.site_title = 'ブログタイトル'
site_setting.site_description = 'ブログの説明' # 新しい属性
site_setting.site_meta_description = 'ブログのmeta description' # 新しい属性
site_setting.save!
