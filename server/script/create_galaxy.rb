#!/usr/bin/env ruby

# Creates galaxy and ensures pool size on it. Can be used on existing galaxies,
# only pool size ensuring is done then.

def help(message)
  puts %Q{
!!! #{message}

Usage: ruby create_galaxy.rb arguments

Where arguments are:
  If you're creating a new galaxy:
    ruleset:ruleset callback_url:url pool_zones:count pool_home_ss:count

    Example:
      ruby create_galaxy.rb ruleset:default callback_url:nebula44.lt \\
      pool_zones:100 pool_home_ss:5000

  If you're ensuring pool on existing galaxy:
    id:galaxy_id zones:zone_count home_ss:ss_count

    Example:
      ruby create_galaxy.rb id:1 zones:100 home_ss:5000

  You can also combine these two modes into one.
    Example:
      ruby create_galaxy.rb ruleset:default callback_url:nebula44.lt \\
      pool_zones:100 pool_home_ss:5000 zones:500 home_ss:50000

  This will firstly create new galaxy with given pool arguments, then
  prepopulate it with given values. If zones and home_ss are not specified
  they are equal to pool_zones and pool_home_ss.
}.strip
  puts
  exit 1
end

help("No arguments given") if ARGV.size == 0

args = ARGV.inject({}) do |hash, arg|
  key, value = arg.split(":", 2)
  help("Key is nil for arg #{arg.inspect}") if key.nil?
  help("Value is nil for arg #{arg.inspect}") if value.nil?

  value = value.to_i if value =~ /^\d+$/
  hash[key.to_sym] = value

  hash
end

puts "Given args: #{args.inspect}"

require File.expand_path(File.dirname(__FILE__) + '/../lib/initializer')
log_writer_config = Logging::Writer.instance.config
log_writer_config.outputs << ConsoleOutput.new(STDOUT) \
  unless log_writer_config.outputs.any? { |o| o.is_a?(ConsoleOutput) }
Logging::Writer.instance.config = log_writer_config
Logging::Writer.instance.level = Logging::Writer::LEVEL_INFO

if args[:id].nil?
  LOGGER.info "Creating new galaxy."
  args.ensure_options!(required: {
    ruleset: String, callback_url: String, pool_zones: Fixnum,
    pool_home_ss: Fixnum
  })
  galaxy = Galaxy.create_galaxy(
    args[:ruleset], args[:callback_url], args[:pool_zones], args[:pool_home_ss]
  )
  args[:id] = galaxy.id
end

galaxy = Galaxy.find(args[:id])
galaxy.pool_free_zones = args[:zones] || args[:pool_zones]
help("Neither zones nor pool_zones specified!") if galaxy.pool_free_zones.nil?
galaxy.pool_free_home_ss = args[:home_ss] || args[:pool_home_ss]
help("Neither home_ss nor pool_home_ss specified!") \
  if galaxy.pool_free_home_ss.nil?

LOGGER.info "Ensuring pool for #{galaxy}."
result = nil
while result.nil? || result.created_zones > 0 || result.created_home_ss > 0
  result = SpaceMule.instance.ensure_pool(galaxy, 10, 100)
end

LOGGER.info "Done! #{galaxy} is created!"