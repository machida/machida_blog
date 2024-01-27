class SiteSetting < ApplicationRecord
  validates :site_title, presence: true
  validates :site_description, presence: true
  validates :site_meta_description, presence: true
  validate :validate_copyright_url

  private

  def validate_copyright_url
    return if copyright_url.blank?

    # URL または '/' で始まるパスかをチェック
    uri = URI.parse(copyright_url)
    unless uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS) || copyright_url.starts_with?('/')
      errors.add(:copyright_url, 'は有効なURLまたはルートパスである必要があります')
    end
  rescue URI::InvalidURIError
    errors.add(:copyright_url, 'は有効なURLフォーマットである必要があります')
  end
end
