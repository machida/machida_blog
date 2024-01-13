class AddDescriptionToSiteSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :site_settings, :site_description, :text
    add_column :site_settings, :site_meta_description, :text
  end
end
