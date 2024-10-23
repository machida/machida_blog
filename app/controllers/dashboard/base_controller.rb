# app/controllers/dashboard/base_controller.rb
module Dashboard
  class BaseController < ApplicationController
    before_action :require_login

    def index
      # 必要な処理をここに記述
    end

    private

    def require_login
      unless user_signed_in?
        redirect_to root_path, alert: 'ログインが必要です。'
      end
    end
  end
end
