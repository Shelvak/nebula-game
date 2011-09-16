#!/usr/bin/env ruby 

INCOME = {
  :our => [
    100,
    {
      :coding => [
        62,
        {
          :infrastructure => [5, :arturaz],
          :server => [40, :arturaz],
          :client => [55,
            [
              [50, :mikis],
              [50, :jho]
            ]
          ]
        }
      ],
      :art => [
        23,
        [
          [70, :tomas],
          [30, :valdas],
        ]
      ],
      :other => [15,
        {
          :management => [5, :arturaz],
          :ideas => [95,
            [
              [30, :arturaz],
              [60, :titan],
              [10, :jho],
            ]
          ]
        }
      ]
    }
  ]
}

TIMES = {
  # 22 kodinimas, 2 - kiti darbai.
  :arturaz => 24 * 20 * 8,
  :mikis => 22 * 20 * 8,
  :jho => 20 * 20 * 8,
  :tomas => 20 * 20 * 8,
  # 24 unitai po 24 val., 47 technologijos po 2val., 14 * 8 val. siaip.
  :valdas => 24 * 24 + 47 * 2 + 14 * 8,
  # 3 darbo menesiai galvojimo.
  :titan => 3 * 20 * 8
}

class IncomeCounter
  attr_reader :users

  def initialize(data)
    @users = {}
    recursive(data)
  end

  def recursive(data, path=[])
    data.each do |key, pair|
      percent, value = pair

      inner_path = path + [[key, percent.to_f / 100]]
      if value.is_a?(Array)
        value.each do |user_percent, user|
          add_user(user, inner_path, user_percent.to_f / 100)
        end
      elsif value.is_a?(Symbol)
        add_user(value, inner_path) 
      elsif value.is_a?(Hash)
        recursive(value, inner_path) 
      else
        raise ArgumentError.new("Invalid value type: #{value.class}")
      end
    end
  end

  def add_user(user, path, user_percent=nil)
    @users[user] ||= []
    path = path + [[nil, user_percent]] unless user_percent.nil?
    @users[user].push path
  end

  def output
    output = {}
    @users.each do |user, parts|
      user_output = {
        :parts => []
      }
      user_percent = 0
      parts.each do |path|
        path_name = []
        path_percent = []
        path.each do |name, percent|
          path_name.push name unless name.nil?
          path_percent.push percent
        end

        path_summed = path_percent.inject { |total, i| total * i }
        user_percent += path_summed

        user_output[:parts].push "%s: %s = %2.1f%" % [
          path_name.join("."),
          path_percent.map { |i| "%d%" % (i * 100) }.join(" * "),
          path_summed * 100
        ]
      end

      user_output[:percent] = user_percent * 100
      output[user] = user_output
    end
    output
  end
end

class TimeCounter
  attr_reader :sum

  def initialize(times)
    @times = times
    @sum = times.map { |_, time| time }.inject(0.0) { |sum, time| sum + time }
  end

  def output
    Hash[@times.map do |name, time|
      [name, [time, time.to_f / @sum * 100]]
    end]
  end
end

require 'pp'
ic = IncomeCounter.new(INCOME)
io = ic.output

tc = TimeCounter.new(TIMES)
to = tc.output

total = 0.0
io.keys.each do |user|
  puts "*** #{user} ***"
  puts "  pagal svarba:"
  iperc = io[user][:percent]
  io[user][:parts].each do |part|
    puts "  - #{part}"
  end
  puts "  Is viso: %2.1f" % iperc
  puts
  puts "  pagal laika:"
  time, tperc = to[user]
  avg = (iperc + tperc) / 2
  puts "  - %dh is %dh = %2.1f" % [time, tc.sum, tperc]
  puts
  puts "  Vidurkis: (%2.1f + %2.1f) / 2 = %2.1f" % [iperc, tperc, avg]
  puts

  total += avg
end

puts "Laisvu %%: %2.1f" % [100 - total]
