sidekiq_redis_connection = 'redis://redis:6379/6'
if Rails.env.development?
  sidekiq_redis_connection = 'redis://127.0.0.1:6379/6'
end

Sidekiq.configure_server do |config|
  config.redis = { url: sidekiq_redis_connection }
end

Sidekiq.configure_client do |config|
  config.redis = { url: sidekiq_redis_connection }
end

# TODO: Add sidekiq-cron config
# Reference: https://github.com/ondrejbartas/sidekiq-cron
schedule_file = 'config/schedule.yml'

if File.exists?(schedule_file) && Sidekiq.server?
  Sidekiq.configure_server do |config|
    config.average_scheduled_poll_interval= 5
  end
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end