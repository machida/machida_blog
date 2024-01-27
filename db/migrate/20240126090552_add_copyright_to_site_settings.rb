class AddCopyrightToSiteSettings < ActiveRecord::Migration[7.1]
  def change
    add_column :site_settings, :copyright, :string
    add_column :site_settings, :copyright_url, :string
  end
end
