LOGGER.outputs += [ConsoleOutput.new(STDOUT)] \
  if File.basename($0) == 'main.rb'
LOGGER.level = GameLogger::LEVEL_DEBUG