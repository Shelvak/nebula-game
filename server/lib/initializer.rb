require 'benchmark'
$load_times = {}
def benchmark(what, &block)
  $load_times[what] = Benchmark.realtime(&block)
end

# This is main initialization, it's included into Spork prefork block.
require File.expand_path(
  File.join(File.dirname(__FILE__), 'boot', 'prefork.rb'))
# This is initialization 
require File.expand_path(
  File.join(File.dirname(__FILE__), 'boot', 'run.rb'))

LOGGER.debug "Initializer load times:"
$load_times.each do |stage, time|
  LOGGER.debug "  %30s: %dms" % [stage, time * 1000]
end