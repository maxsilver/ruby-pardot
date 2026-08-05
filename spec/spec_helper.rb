# frozen_string_literal: true

require 'rubygems'
require 'cgi'
require 'tempfile'
require 'rspec'

require 'crack'
require 'httparty'

require 'ruby-pardot'

# Patch for fakeweb 1.3.0 compatibility with Ruby 3.2+
File.singleton_class.class_eval { alias_method :exists?, :exist? } unless File.respond_to?(:exists?)

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
