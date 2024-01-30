class CreateArticles < ActiveRecord::Migration[7.1]
  def change
    unless table_exists?(:articles)
      create_table :articles do |t|
        t.string :title
        t.string :body

        t.timestamps
      end
    end
  end
end
