module Dashboard
  class FlickrController < Dashboard::BaseController
    def search_photos
      photos = Flickr.photos.search(text: flickr_params[:text], per_page: 10)
      build_urls(photos)
      respond_to do |format|
        format.js
        format.html { render partial: 'photos', photos: @photos }
      end
    end

    private

    def flickr_params
      params.require(:flickr).permit(:text)
    end

    def build_urls(photos)
      @photos = photos.map do |photo|
        "https://farm#{photo.farm}.staticflickr.com/#{photo.server}/#{photo.id}_#{photo.secret}.jpg"
      end
    end
  end
end
