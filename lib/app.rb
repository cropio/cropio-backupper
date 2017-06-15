require 'active_record'
require 'cropio'
require 'redis'
require 'yaml'

module App
  ROOT = File.expand_path('../..', __FILE__)
  DB_CONFIG = YAML.load_file File.join ROOT, 'config', 'database.yml'

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

  def db_connection(options = DB_CONFIG.fetch('db'))
    ActiveRecord::Base.establish_connection(options)
  end

  def api_connection
    email = ENV.fetch('CROPIO_LOGIN', '')
    password = ENV.fetch('CROPIO_PASSWORD', '')
    Cropio.credentials = { email: email,
                           password: password}
  end

  db_connection
  api_connection
end
