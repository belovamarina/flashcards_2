class CardImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog unless Rails.env.test?

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  process resize_to_fit: [360, 360]
  process convert: 'jpg'

  version :thumb do
    process resize_to_fit: [140, 140]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
