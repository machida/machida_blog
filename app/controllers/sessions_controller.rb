class SessionsController < ApplicationController
  def new
    if user_signed_in?
      redirect_to root_path, notice: 'すでにログインしています。'
    end
  end

  def create
    login_param = params[:session][:login]
    user = User.find_by(email: login_param&.downcase) || User.find_by(account_id: login_param)

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to root_path
    else
      flash.now[:alert] = 'ログイン情報が正しくありません。'
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'ログアウトしました。' }
      format.turbo_stream { redirect_to root_path, flash.now[:notice] = 'ログアウトしました。' }
    end
  end
end
