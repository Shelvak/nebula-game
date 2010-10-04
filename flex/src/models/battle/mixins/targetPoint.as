import config.BattleConfig;

import flash.geom.Point;

public function get targetPoint() : Point
{
   return BattleConfig.getUnitTargetPoint(type);
}