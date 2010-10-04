#!/usr/bin/env ruby

require "rubygems"
require "daemons"

Daemons.run(
  File.expand_path(File.join(File.dirname(__FILE__), 'main.rb')),
  :app_name => 'nebula_server',
  :dir_mode => :normal,
  :dir => File.join(File.dirname(__FILE__), '..', 'run'),
  :monitor => false
)
