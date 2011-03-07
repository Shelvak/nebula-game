#!/usr/bin/env ruby
require 'time'

BLOCK_END = "[END "
REQ_END = "[END of REQUEST"
CB_END = "[END of Callback"

# Request metrics
req_secs = 0.0
reqs = 0
# Callback metrics
cb_secs = 0.0
cbs = 0

if ARGV.size < 2
  $stderr.write "Usage: #{$0} mode config|logfile\n"
  $stderr.write "\n"
  $stderr.write "  mode can be 'counts', 'time' or 'human' \n"
  exit 1
end

if ["counts", "time", "human"].include?(ARGV[0])
  mode = ARGV[0].to_sym
else
  $stderr.write "Unknown mode #{ARGV[0].inspect}!\n"
  exit 2
end

case ARGV[1]
when "config"
  case mode
  when :counts
    puts "graph_title Request & callback counts"
    puts "graph_category nebula44"
    puts "graph_args --base 1000 -l 0"
    puts "graph_vlabel Count"
    puts "graph_printf %6.0lf"
    puts "requests.label Requests"
    puts "requests.type DERIVE"
    puts "requests.min 0"
    puts "callbacks.label Callbacks"
    puts "callbacks.type DERIVE"
    puts "callbacks.min 0"
  when :time
    puts "graph_title Request & callback average times"
    puts "graph_category nebula44"
    puts "graph_args -l 0"
    puts "graph_vlabel Time (ms)"
    puts "requests.label Avg. request time"
    puts "requests.type GAUGE"
    puts "requests.min 0"
    puts "callbacks.label Avg. callback time"
    puts "callbacks.type GAUGE"
    puts "callbacks.min 0"
  when :human
    puts "What ya want, human?"
  end
else
  File.open(ARGV[1]) do |f|
    begin
      loop do
        line = f.readline

        if line.start_with?(BLOCK_END)
          seconds = line.split[-2].to_f
          # If it's a request or callback block.
          if seconds > 0
            if line.start_with?(REQ_END)
              req_secs += seconds
              reqs += 1
            elsif line.start_with?(CB_END)
              cb_secs += seconds
              cbs += 1
            end
          end
        end
      end
    rescue EOFError
    end
  end

  avg_req = reqs == 0 ? 0 : (req_secs / reqs * 1000).round
  avg_cb = cbs == 0 ? 0 : (cb_secs / cbs * 1000).round

  case mode
  when :counts
    puts "requests.value #{reqs}"
    puts "callbacks.value #{cbs}"
  when :time
    puts "requests.value #{avg_req}"
    puts "callbacks.value #{avg_cb}"
  when :human
    puts "%d requests with avg of %d ms" % [reqs, avg_req]
    puts "%d callbacks with avg of %d ms" % [cbs, avg_cb]
  end
end