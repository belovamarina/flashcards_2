if Rails.env.test?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
else
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'                          # required
    config.fog_credentials = {
        provider:              'AWS',                        # required
        aws_access_key_id:     ENV['aws_access_key_id'],     # required
        aws_secret_access_key: ENV['aws_secret_access_key'], # required
    }
    config.fog_directory  = 'flashcards-mkdevme'             # required
    config.fog_public     = true                             # optional, defaults to true
    config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" } # optional, defaults to {}
  end
end

