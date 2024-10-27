class SessionsController < ApplicationController
  def new
    if user_signed_in?
      flash[:notice] = 'すでにログインしています。'
      redirect_to root_path
    end
  end

  def create
    login_param = params[:session][:login]
    user = User.find_by(email: login_param&.downcase) || User.find_by(account_id: login_param)

    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = 'ログインしました。'
      redirect_to root_path
    else
      flash.now[:alert] = 'ログイン情報が正しくありません。'
      render 'new'
    end
  end

  def destroy
    reset_session
    @current_user = nil

    respond_to do |format|
      format.html do
        flash[:notice] = 'ログアウトしました。'
        redirect_to root_path
      end

      format.turbo_stream do
        flash.now[:notice] = 'ログアウトしました。'
        render turbo_stream: turbo_stream.update('flash', partial: 'shared/flash')
        redirect_to root_path
      end
    end
  end
end
