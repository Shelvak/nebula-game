import config.BattleConfig;

import flash.geom.Rectangle;

public function get box() : Rectangle
{
   return BattleConfig.getUnitBox(type);
}