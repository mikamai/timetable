CarrierWave.configure do |config|
  if ENV['S3_BUCKET']
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      region:                ENV.fetch('AWS_REGION', 'eu-west-1'),
      aws_access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    }
    config.fog_directory = ENV['S3_BUCKET']
    config.fog_public = false
    config.storage = :fog
  else
    config.storage = :file
  end
end
