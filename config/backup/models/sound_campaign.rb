# encoding: utf-8

Backup::Model.new :sound_campaign, 'Backup SoundCampaign data' do
  require 'yaml'
  require 'dotenv'
  
  # Load settings:
  APP_ROOT   = Pathname.new(File.expand_path('../../../', Config.config_file))
  APP_ENV    = ENV['RAILS_ENV'] || 'production'
  DATABASE   = YAML.load_file(APP_ROOT.join('config', 'database.yml'))[APP_ENV]
  SETTINGS   = YAML.load_file(APP_ROOT.join('config', 'application.yml'))[APP_ENV]
  CHUNK_SIZE = 250
  Dotenv.load  APP_ROOT.join('.env')
  
  def store_with_s3?
    !!(
      ENV['AWS_ACCESS_KEY_ID'] &&
      ENV['AWS_SECRET_ACCESS_KEY']
    )
  end
  
  def notify_by_email?
    !!(
      ENV['MANDRILL_USERNAME']  &&
      ENV['MANDRILL_APIKEY']    &&
      SETTINGS['contact_email'] &&
      SETTINGS['backup_email']
    )
  end
  
  def notify_by_campfire?
    !!(
      ENV['CAMPFIRE_API_KEY']   &&
      ENV['CAMPFIRE_SUBDOMAIN'] &&
      ENV['CAMPFIRE_ROOM_ID']
    )
  end
  
  # Split the backup file in to chunks of 250 megabytes:
  split_into_chunks_of 250
  
  database PostgreSQL do |db|
    db.name     = DATABASE['database']
    db.username = DATABASE['username']
    db.password = DATABASE['password']
    
    if DATABASE['host']
      db.host   = DATABASE['host']
      db.port   = DATABASE['password'] || 5432
    end
  end
  
  compress_with Gzip
  
  store_with S3 do |s3|
    s3.access_key_id     = ENV['AWS_ACCESS_KEY_ID']
    s3.secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    s3.bucket            = ENV['AWS_BUCKET']
    s3.path              = 'backups'
    s3.keep              = 15
  end if store_with_s3?
  
  notify_by Campfire do |campfire|
    campfire.on_success = true
    campfire.on_warning = true
    campfire.on_failure = true
    
    campfire.api_token = ENV['CAMPFIRE_API_KEY']
    campfire.subdomain = ENV['CAMPFIRE_SUBDOMAIN']
    campfire.room_id   = ENV['CAMPFIRE_ROOM_ID']
  end if notify_by_campfire?
  
  notify_by Mail do |mail|
    # When to mail:
    mail.on_success = true
    mail.on_warning = true
    mail.on_failure = true
    
    # Mail config:
    mail.from = SETTINGS['contact_email']
    mail.to   = SETTINGS['backup_email']
    
    # SMTP config:
    mail.address        = 'smtp.mandrillapp.com'
    mail.port           = 25
    mail.authentication = 'login'
    mail.encryption     = :starttls
    mail.user_name      = ENV['MANDRILL_USERNAME']
    mail.password       = ENV['MANDRILL_APIKEY']
  end if notify_by_email?
end
