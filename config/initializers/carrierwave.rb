CarrierWave.configure do |config|
  if ENV['S3_BUCKET']
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      provider:              'AWS',
      region:                ENV.fetch('AWS_REGION', 'eu-west-1')
    }
    config.fog_directory = ENV['S3_BUCKET']
    config.fog_public = false
    config.storage = :fog
  else
    config.storage = :file
  end
end
