class ImagesController < ApplicationController
  def create
    image = Image.create!(file: params[:file]) # ImageはActiveStorageがアタッチされたモデル
    if image.save
      render json: { url: url_for(image.file) }
    else
      flash[:alert] = '画像のアップロードに失敗しました。'
    end
  end
end
