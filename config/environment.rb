require 'dotenv/load'
require 'bundler/setup'
Bundler.require(:default)

require_relative '../lib/cli'
require_relative '../lib/article'
