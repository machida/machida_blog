# app/controllers/dashboard/base_controller.rb
module Dashboard
  class BaseController < ApplicationController
    before_action :require_login

    def index
    end

    private

    def require_login
      unless user_signed_in?
        flash[:alert] = 'ログインが必要です。'
        redirect_to dashboard_login_path
      end
    end
  end
end
