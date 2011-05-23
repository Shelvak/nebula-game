LOGGER.outputs += [ConsoleOutput.new(STDOUT)] unless rake?
LOGGER.level = GameLogger::LEVEL_DEBUG