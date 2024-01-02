class Article < ApplicationRecord
  validates :status, inclusion: { in: ['draft', 'published'] }

  scope :published, -> { where(status: 'published') }
  scope :drafts, -> { where(status: 'draft') }
end
