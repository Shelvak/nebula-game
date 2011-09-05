#!/usr/bin/env ruby

# Solves a,b,c for quadratic equation given 3 points.

if ARGV.size != 3
  puts "Usage: #{$0} x1,y1 x2,y2 x3,y3"
  exit 1
end

def read(pair)
  pair.split(",").map(&:to_f)
end

x1, y1 = read(ARGV[0])
x2, y2 = read(ARGV[1])
x3, y3 = read(ARGV[2])

xd = x2 - x1
xd2 = x1 ** 2 - x2 ** 2
yd = y2 - y1

a = (
  y3 * xd - x3 * yd - y1 * xd + x1 * yd
) / (
  x3 ** 2 * xd + x3 * xd2 - x1 ** 2 * xd - x1 * xd2
)

b = (yd + a * xd2) / xd
c = y1 - x1 ** 2 * a - x1 * b

puts "a: #{a}"
puts "b: #{b}"
puts "c: #{c}"
puts

q = lambda do |x, exp_y|
  puts "x: #{x} => #{a * x ** 2 + b * x + c} (exp: #{exp_y})"
end

q.call(x1, y1)
q.call(x2, y2)
q.call(x3, y3)
