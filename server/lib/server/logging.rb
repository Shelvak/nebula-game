# Empty module for namespace.
module Logging; end

# Manually require logging classes because autoloader hasn't been set up yet.
require File.dirname(__FILE__) + '/console_output.rb'
require File.dirname(__FILE__) + '/logging/thread_router.rb'
require File.dirname(__FILE__) + '/logging/writer.rb'
require File.dirname(__FILE__) + '/logging/logger.rb'