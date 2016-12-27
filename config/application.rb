require File.expand_path('../boot', __FILE__)
require 'rails/all'
Bundler.require(*Rails.groups)


module Cworks
  class Application < Rails::Application
    config.active_job.queue_adapter = :delayed_job
    config.active_record.raise_in_transactional_callbacks = true
    config.autoload_paths += [config.root.join('lib').to_s]

    unless Rails.env.test?
      config.before_initialize do
        if ENV['AWS_BUCKET']
          config.paperclip_defaults = {
            :storage => :s3,
            :s3_credentials => {
              :bucket => ENV['AWS_BUCKET'],
              :access_key_id => ENV['AWS_ACCESS_KEY_ID'],
              :secret_access_key => ENV['AWS_SECRET_ACCESS_KEY']
            },
            :url =>'compworks.s3.amazonaws.com',
            :path => '/:class/:attachment/:id_partition/:style/:filename',
            :s3_host_name => 's3-us-west-2.amazonaws.com'
          }
        end
      end
    end

  end
end
