# app/controllers/dashboard/profiles_controller.rb
module Dashboard
  class ProfilesController < ApplicationController
    before_action :require_login

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update(user_params)
        redirect_to dashboard_root_path, notice: 'プロフィールが更新されました。'
      else
        flash.now[:alert] = '更新に失敗しました。'
        render :edit
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :account_id, :password, :password_confirmation)
    end

    def require_login
      redirect_to root_path, alert: 'ログインが必要です。' unless user_signed_in?
    end
  end
end
