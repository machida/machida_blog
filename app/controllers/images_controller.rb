class ImagesController < ApplicationController
  def create
    image = Image.create!(file: params[:file]) # ImageはActiveStorageがアタッチされたモデル
    if image.save
      render json: { url: url_for(image.file) }
    else
      # 保存失敗時の処理
    end
  end
end
