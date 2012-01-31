log_writer_config.outputs << ConsoleOutput.new(STDOUT) unless rake?
log_writer_config.level = :debug