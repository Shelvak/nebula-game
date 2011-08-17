#!/bin/bash
server_name="$1"
if [ -z "$server_name" ]; then
  echo "Usage: $0 server_name"
  exit -1
fi

# Loop predicate is an JVM7 bug.
# http://www.lucidimagination.com/search/document/1a0d3986e48a9348/warning_index_corruption_and_crashes_in_apache_lucene_core_apache_solr_with_java_7
JRUBY_OPTS="-J-Dname=$server_name -J-Djruby.jit.max=25000 \
--server -J-XX:+TieredCompilation -J-XX:-UseLoopPredicate"
rundir=$(readlink -f "$(dirname $0)/..")
logdir=$(readlink -f "$rundir/../log")
logfile="$logdir/daemon.log"

echo >> "$logfile"
echo >> "$logfile"
echo >> "$logfile"
echo "#### STARTING DAEMON ####" >> "$logfile"
echo >> "$logfile"
date >> "$logfile"
echo >> "$logfile"
nohup jruby "$rundir/main.rb" >> "$logfile" 2>/dev/null &
