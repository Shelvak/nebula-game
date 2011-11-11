import config.BattleConfig;

import flash.geom.Point;

public function get hitBox() : Rectangle
{
   return BattleConfig.getUnitHitBox(type);
}

public function get targetPoint() : Point
{
   return new Point(hitBox.x,  hitBox.y);
}