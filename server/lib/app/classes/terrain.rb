# Defines terrain types for planet.
#
# This cannot be SsObject::Planet::Terrain because:
# 1) It's very long and ugly.
# 2) It's referenced from config. However it tries to load up Planet object
# and execute code that depends on config whilst config is still being loaded.
module Terrain
  EARTH = 0
  DESERT = 1
  MUD = 2
  TWILIGHT = 3
end