require 'bundler/setup'
require 'active_support'
require 'active_support/core_ext'
require 'cropio'
require_relative './lib/app'
require_relative './lib/models/crop'
require_relative './lib/downloader'

include Cropio::Resources

desc 'Download data from Cropio'
task :download_data do
  Downloader.download_data
end
