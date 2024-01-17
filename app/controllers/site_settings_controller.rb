class SiteSettingsController < ApplicationController
  before_action :authenticate_user

  def edit
    @site_setting = SiteSetting.first
  end

  def update
    @site_setting = SiteSetting.first
    if @site_setting.update(site_setting_params)
      respond_to do |format|
        format.html { redirect_to root_path, notice: 'サイト設定が更新されました。' }
      end
    else
      render :edit
    end
  end

  private

  def site_setting_params
    params.require(:site_setting).permit(:site_title, :site_description, :site_meta_description)
  end
end
