require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module SoundCampaign
  class Application < Rails::Application
    # Load settings:
    require File.expand_path('../../app/models/settings', __FILE__)
    
    # Timezone:
    config.time_zone = 'UTC'
    
    # I18n:
    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    
    # Asset pipeline:
    config.assets.initialize_on_precompile = false
    config.assets.precompile += %w(teaser.css teaser.js modernizr.js)
    
    # ActionMailer:
    config.action_mailer.default_url_options = { host: 'soundcampaign.com' }
    
    # ActiveRecord:
    config.active_record.whitelist_attributes = false
    
    # Development:
    console do
      require 'pry'
      config.console = Pry
    end if Rails.env.development?
    
    # Generators:
    config.generators do |g|
      g.helper false
      g.assets false
      g.template_engine :erb
      g.test_framework  :rspec, fixture: false, views: false
    end
    
    # Paperclip & S3:
    if ENV['AWS_BUCKET'].present? && ENV['AWS_ACCESS_KEY_ID'].present?
      config.paperclip_defaults = {
        storage: :s3,
        s3_credentials: {
          bucket:            ENV['AWS_BUCKET'],
          access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
          secret_access_key: ENV['AWS_SECRET_ACCESS_KEY']
        }
      }
    end
  end
end
