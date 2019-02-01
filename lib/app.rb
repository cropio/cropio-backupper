require 'active_record'
require 'cropio'
require 'redis'
require 'yaml'

module App
  ROOT = File.expand_path('../..', __FILE__)
  DB_CONFIG = YAML.load_file File.join ROOT, 'config', 'database.yml'
  ALLOWED_PERIODS = %w[hour day week month year]

  DB_CONFIG['db'].update(DB_CONFIG['db']) do |_, v|
    if v.is_a?(String) && v.include?('ENV')
      v = eval(v)
    else
      v
    end
  end

  REDIS = Redis.new(host: ENV['REDIS_HOST'])
  START_DOWNLOAD_YEAR = Time.new(ENV.fetch('START_DOWNLOAD_YEAR', 2000).to_i)

  module_function

  def self.download_period
    @download_period ||= begin
      user_period = ENV.fetch('DOWNLOAD_PERIOD', 'year')
      period = ALLOWED_PERIODS.include?(user_period) ? user_period : ALLOWED_PERIODS.last
      eval("1.#{period}")
    end
  end

  def login_through_credentials
    Cropio.credentials = { email: ENV.fetch('CROPIO_LOGIN', ''),
                           password: ENV.fetch('CROPIO_PASSWORD', '')}
  end

  def login_through_api_token(api_token)
    Cropio.api_token = api_token
  end

  def db_connection(options = DB_CONFIG.fetch('db'))
    ActiveRecord::Base.establish_connection(options)
  end

  def api_connection
    api_token = ENV.fetch('API_TOKEN', '')
    return login_through_api_token(api_token) unless api_token.empty?
    login_through_credentials
  end

  db_connection
  api_connection
end
