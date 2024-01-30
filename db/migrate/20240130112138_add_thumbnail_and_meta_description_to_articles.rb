class AddThumbnailAndMetaDescriptionToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :thumbnail, :string
    add_column :articles, :meta_description, :text
  end
end
