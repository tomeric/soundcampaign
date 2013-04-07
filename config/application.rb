require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Assets should be precompiled for production (so we don't need the gems loaded then)
Bundler.require(*Rails.groups(assets: %w(development test)))

module SoundCampaign
  class Application < Rails::Application
    # Timezone:
    config.time_zone = 'UTC'
    
    # I18n:
    config.i18n.default_locale = :en
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]
    
    # Asset pipeline:
    config.assets.initialize_on_precompile = false
    config.assets.precompile += %w(teaser.css teaser.js lib/modernizr.min.js)
    
    # ActionMailer:
    config.action_mailer.default_url_options = { host: 'soundcampaign.com' }
    
    # ActiveRecord:
    config.active_record.whitelist_attributes = false
    
    # Development:
    console do
      require 'pry'
      config.console = Pry
    end if Rails.env.development?
    
    config.generators do |g|
      g.helper false
      g.assets false
      g.template_engine :erb
      g.test_framework  :rspec, fixture: false, views: false
    end
  end
end
