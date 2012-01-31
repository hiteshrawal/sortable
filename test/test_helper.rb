require 'rubygems'
require 'logger'
require 'active_record'

ActiveRecord::Base.logger = Logger.new(File.dirname(__FILE__) + '/debug.log')
ActiveRecord::Base.configurations = YAML::load(File.open(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(ENV['DB'] || 'mysql')

require File.dirname(__FILE__) + '/../init.rb'
require File.dirname(__FILE__) + '/models/book'
require File.dirname(__FILE__) + '/models/author'

require 'test/unit'
require 'factory_girl'
Factory.find_definitions

require 'database_cleaner'
DatabaseCleaner.strategy = :truncation

load(File.dirname(__FILE__) + '/schema.rb')
