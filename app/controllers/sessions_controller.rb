class SessionsController < ApplicationController
  def new
    if user_signed_in?
      redirect_to articles_path, notice: 'すでにログインしています。'
    end
  end

  def create
    user = User.find_by(email: params[:session][:login].downcase) || User.find_by(account_id: params[:session][:login])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to articles_path
    else
      render 'new'
    end
  end

  def destroy
    session.delete(:user_id)
    @current_user = nil
    respond_to do |format|
      format.html { redirect_to articles_path, notice: 'ログアウトしました。' }
      format.turbo_stream { flash.now[:notice] = 'ログアウトしました。' }
    end
  end
end
