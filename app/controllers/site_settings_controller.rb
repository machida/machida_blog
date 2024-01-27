class SiteSettingsController < ApplicationController
  before_action :authenticate_user
  before_action :set_site_setting, only: [:edit, :update]

  def edit
  end

  def update
    if @site_setting.update(site_setting_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'サイト設定が更新されました。' }
      end
    else
      render :edit
    end
  end

  private

  def set_site_setting
    @site_setting = SiteSetting.first_or_initialize
  end

  def site_setting_params
    params.require(:site_setting).permit(:site_title, :site_description, :site_meta_description, :copyright, :copyright_url)
  end
end
