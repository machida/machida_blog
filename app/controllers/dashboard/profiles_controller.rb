# app/controllers/dashboard/profiles_controller.rb
module Dashboard
  class ProfilesController < ApplicationController
    before_action :require_login

    def show
      redirect_to edit_dashboard_profile_path
    end

    def edit
      @user = current_user
    end

    def update
      @user = current_user
      if @user.update(user_params)
        flash[:notice] = 'プロフィールが更新されました。'
        redirect_to dashboard_root_path
      else
        flash.now[:alert] = @user.errors.full_messages
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
