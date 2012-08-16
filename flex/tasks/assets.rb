require 'yaml'
require 'java'
require 'active_support/core_ext'

module Tasks
  module Assets; end
end

require File.dirname(__FILE__) + '/assets/asset'
require File.dirname(__FILE__) + '/assets/bundler'
require File.dirname(__FILE__) + '/assets/processor'
