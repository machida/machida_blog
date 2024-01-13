class SiteSetting < ApplicationRecord
  validates :site_title, presence: true
  validates :site_description, presence: true
  validates :site_meta_description, presence: true
end
