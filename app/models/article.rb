class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  validates :status, inclusion: { in: ['draft', 'published'] }

  scope :published, -> { where(status: 'published') }
  scope :drafts, -> { where(status: 'draft') }
end
