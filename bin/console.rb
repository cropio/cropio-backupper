#!/usr/bin/env ruby

require 'bundler/setup'
require 'pry'
require 'active_support'
require 'active_support/core_ext'
require 'cropio'
require_relative '../lib/app'
require_relative '../lib/models/crop'
require_relative '../lib/downloader'

include Cropio::Resources

Pry.start
