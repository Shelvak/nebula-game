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
-X+C -J-Xms128M -J-Xmx1024M -J-XX:MaxPermSize=256m"

jmxpass="$HOME/config/jmx.password"
if [ -e "$jmxpass" ]; then
  opts="$opts \
-J-Dcom.sun.management.jmxremote.port=55100 \
-J-Dcom.sun.management.jmxremote.password.file=$jmxpass \
-J-Dcom.sun.management.jmxremote.ssl=false"
fi

appdir=$(readlink -f "$(dirname $0)/..")
logdir=$(readlink -f "$appdir/../log")
logfile="$logdir/daemon.log"
rundir=$(readlink -f "$appdir/../run")

echo >> "$logfile"
echo >> "$logfile"
echo >> "$logfile"
echo "#### STARTING DAEMON ####" >> "$logfile"
nohup jruby $opts "$appdir/main.rb" >> "$logfile" 2>&1 &
pid=$!
echo "Daemon pid: $pid" >> "$logfile"
echo "$pid" > "$rundir/daemon.pid"
echo >> "$logfile"
date >> "$logfile"
echo >> "$logfile"
