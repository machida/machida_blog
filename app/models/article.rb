class Article < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :body, presence: true
  validates :status, inclusion: { in: %w[draft published] }
  validates :meta_description, length: { maximum: 160 }, allow_blank: true
  validate :published_at_present_if_published, on: :update

  scope :published, -> { where(status: 'published') }
  scope :drafts, -> { where(status: 'draft') }

  before_validation :set_published_at_if_published

  def next_article
    Article.where("published_at > ? AND status = ?", published_at, 'published')
           .order(published_at: :asc).first
  end

  def previous_article
    Article.where("published_at < ? AND status = ?", published_at, 'published')
           .order(published_at: :desc).first
  end

  private

  # 公開時に公開日時を設定
  def set_published_at_if_published
    if status == 'published' && published_at.blank?
      self.published_at = Time.current
    end
  end

  # 公開ステータスのときに公開日時が必要
  def published_at_present_if_published
    if status == 'published' && published_at.blank?
      errors.add(:published_at, '記事を公開するには公開日の設定が必要です。')
    end
  end
end
