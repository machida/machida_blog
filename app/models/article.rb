class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true
  validates :status, inclusion: { in: ['draft', 'published'] }
  validate :published_at_present_if_published

  scope :published, -> { where(status: 'published') }
  scope :drafts, -> { where(status: 'draft') }
  belongs_to :user

  private

  def published_at_present_if_published
    if status == 'published' && published_at.blank?
      errors.add(:published_at, '記事を公開するには公開日の設定が必要です。')
    end
  end
end
