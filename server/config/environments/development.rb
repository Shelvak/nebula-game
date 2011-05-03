LOGGER.outputs += [ConsoleOutput.new(STDOUT)]# \
  #if File.basename($0) == 'main.rb' && RUBY_PLATFORM !~ /mingw/
LOGGER.level = GameLogger::LEVEL_DEBUG