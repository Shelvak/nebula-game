#!/bin/bash
server_name="$1"
if [ -z "$server_name" ]; then
  echo "Usage: $0 server_name"
  exit -1
fi

export JRUBY_OPTS="" # Clear JRuby opts
export JAVA_OPTS=""  # Clear Java opts

opts="--1.9 -J-Dname=$server_name -J-Djruby.jit.max=25000 \
--server -J-XX:+TieredCompilation \
-X+C -J-Xms128M -J-Xmx1024M -J-XX:MaxPermSize=256m \
-Xreify.classes=true"

jmxpass="$HOME/config/jmx.password"
if [ -e "$jmxpass" ]; then
  opts="$opts \
-J-Dcom.sun.management.jmxremote.port=55100 \
-J-Dcom.sun.management.jmxremote.password.file=$jmxpass \
-J-Dcom.sun.management.jmxremote.ssl=false"
fi

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
nohup jruby $opts "$rundir/main.rb" >> "$logfile" 2>&1 &
