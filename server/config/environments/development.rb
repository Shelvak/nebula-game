log_writer_config.outputs << ConsoleOutput.new(STDOUT) unless rake?
log_writer_config.level = :debug

# Console drop-out thread.
Thread.new do
  loop do
    if $IRB_RUNNING
      sleep 1
    else
      input = gets.chomp
      case input
      when "cc"
        puts "\n\nDropping into IRB shell. Server operation suspended."
        puts "Press CTRL+C again to exit the server.\n\n"

        puts "Pausing callback manager..."
        Celluloid::Actor[:callback_manager].pause
        puts "Starting IRB session..."
        IRB.start_session(ROOT_BINDING)
        puts "\nIRB done. Server operation resumed.\n\n"
      end
    end
  end
end