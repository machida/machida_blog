class AddStatusAndPublishedAtToArticles < ActiveRecord::Migration[7.1]
  def change
    add_column :articles, :status, :string
    add_column :articles, :published_at, :datetime
  end
end
