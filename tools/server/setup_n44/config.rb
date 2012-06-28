# General configuration.

DISTRO = "lucid"
USER = "spacegame"
DOMAIN = "com" # In what ending does your domain end
HOSTNAME = "worg.nebula44.#{DOMAIN}"
LOCALE = "en" # Your locale.
MUNIN_MASTER = "188.40.91.110" # thor.nebula44.com

### Server Configuration ###
JRUBY = '1.6.7-head'
JRUBY_INSTALL_OPTS = "--branch jruby-1_6"

### Client Configuration ###

# Cannot be same as server hostname because of vhost madness!
CLIENT_HOSTNAME = "worg-static.nebula44.#{DOMAIN}"

### Web Configuration ###

## Apache Event MPM ##

# StartServers: initial number of server processes to start
MPM_EVENT_START_SERVERS      = 2
# MinSpareThreads: minimum number of worker threads which are kept spare
MPM_EVENT_MIN_SPARE_THREADS  = 25
# MaxSpareThreads: maximum number of worker threads which are kept spare
MPM_EVENT_MAX_SPARE_THREADS  = 75
MPM_EVENT_THREAD_LIMIT       = 64
# ThreadsPerChild: constant number of worker threads in each server process
MPM_EVENT_THREADS_PER_CHILD  = 25
# MaxClients: maximum number of simultaneous client connections
MPM_EVENT_MAX_CLIENTS        = 150
# MaxRequestsPerChild: maximum number of requests a server process serves
MPM_EVENT_MAX_REQS_PER_CHILD = 0

## PHP Configuration ##

PHP_MEM_LIMIT = '512M'
PHP_MAX_UPLOAD = '10M'
PHP_MAX_POST = '15M'

## Ruby Configuration ##

WEB_RUBY_VERSION = '1.9.2'
WEB_RUBY_GEMSET = 'web'
PASSENGER_MIN_INSTANCES = 6
PASSENGER_MAX_POOL_SIZE = 18
PASSENGER_POOL_IDLE_TIME = 3600

## General configuration ##
GA_ACCOUNT_ID = {
  "lt" => "UA-1799100-9",
  "com" => "UA-1799100-10"
}[DOMAIN]

FORUM_LANG = {
  "en" => "English",
  "lt" => "Lithuanian"
}[LOCALE]

raise "Did you actually change me?"
