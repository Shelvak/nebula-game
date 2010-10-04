#!/usr/bin/env ruby

require 'rubygems'
require 'yaml'

class Keygen
  STEP = 4
  TIME_MULT = 100000

  def self.part_string(string, step, separator="-")
    parts = []
    0.step(string.length - 1, step) do |start_index|
      parts.push string[start_index...start_index + step]
    end
    parts.join(separator)
  end

  def self.get_key(id, event_name)
    ("%s-%04d-%s-%s" % [
      part_string((Time.now.to_f * TIME_MULT).to_i.to_s(16), STEP),
      id,
      event_name,
      (4096 + rand(61439)).to_s(16)
    ]).upcase
  end
end

90.times do |i|
  puts Keygen.get_key(i, "ITCITY")
end
