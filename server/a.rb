trap("INT") do
  puts "INT FROM MAIN!"
end

t = fork do
  trap("INT") do
    puts "INT FROM CHILD!"
  end
  loop do
    sleep 1
    puts "ping from child"
  end
end

Process.detach t

loop do
  sleep 1
  puts "ping from main"
end
