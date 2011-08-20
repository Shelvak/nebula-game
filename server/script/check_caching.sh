#!/bin/bash

if [ "$1" == "" ]; then
  echo Usage: $0 base_url
  echo
  echo base_url must not end in /
  exit
fi

for f in index.html assets/checksums locale/checksums; do
  url="$1/$f"
  echo -n "$url ... "
  uncached=$(wget --server-response -O /dev/null "$url" 2>&1 | grep "Cache-Control: no-cache")
  if [ -n "$uncached" ]; then
    echo "uncached. OK."
  else
    echo "Cached! FAIL!"
  fi
done

for f in game.js SpaceGame.swf assets/ImagesAchievementsBundle.swf locale/en.xml; do
  url="$1/$f?$RANDOM"
  echo -n "$url ... "
  cached=$(wget --server-response -O /dev/null "$url" 2>&1 | grep "Cache-Control: max-age=")
  if [ -n "$cached" ]; then
    timestr="max-age=31536000"
    if [ -n "$(echo $cached | grep "$timestr")" ]; then
      echo "cached. OK."
    else
      echo "cached, but wrong time. Expected $timestr, but was $cached."
    fi
  else
    echo "Uncached! FAIL!"
  fi
done
