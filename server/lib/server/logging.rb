# Empty module for namespace.
module Logging; end

# Manually require logging classes because autoloader hasn't been set up yet.
dir = File.dirname(__FILE__)
require dir + '/logging/thread_router.rb'
require dir + '/logging/writer.rb'
require dir + '/logging/logger.rb'