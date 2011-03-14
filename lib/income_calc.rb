#!/usr/bin/env ruby 

INCOME = {
  :our => [
    100,
    {
      :coding => [
        68,
        {
          :infrastructure => [5, :arturaz],
          :server => [40, :arturaz],
          :client => [50,
            [
              [55, :mikis],
              [45, :jho]
            ]
          ],
          :web => [5, :deividas]
        }
      ],
      :art => [
        22,
        [
          [60, :tomas],
          [40, :valdas],
        ]
      ],
      :other => [10,
        {
          :management => [20, :arturaz],
          :ideas => [80,
            [
              [50, :arturaz],
              [50, :titan]
            ]
          ]
        }
      ]
    }
  ]
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

  def income(amount)
    @users.each do |user, parts|
      puts "#{user}:"
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

        puts "  %s: %s = %2.1f%" % [
          path_name.join("."),
          path_percent.map { |i| "%d%" % (i * 100) }.join(" * "),
          path_summed * 100
        ]
      end

      puts "-" * 60
      puts "Total: %2.1f%% * %s = %s" % [
        user_percent * 100,
        amount, 
        amount * user_percent
      ]

      puts
    end
  end
end

require 'pp'
ic = IncomeCounter.new(INCOME)
ic.income((ARGV[0] || 1000).to_i)
