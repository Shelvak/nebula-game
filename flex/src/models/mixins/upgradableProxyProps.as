// ActionScript file


[Required]
/**
 * Proxy property to <code>upgradePart.level</code>.
 */
public function set level(value:int) : void
{
   upgradePart.level = value;
}
/**
 * @private
 */
public function get level() : int
{
   return upgradePart.level;
}


[Required]
/**
 * Proxy property to <code>upgradePart.lastUpdate</code>.
 */
public function set lastUpdate(value:Date) : void
{
   upgradePart.lastUpdate = value;
}
/**
 * @private 
 */
public function get lastUpdate() : Date
{
   return upgradePart.lastUpdate;
}


[Required]
/**
 * Proxy property to <code>upgradePart.upgradeEndsAt</code>.
 */
public function set upgradeEndsAt(value:Date) : void
{
   upgradePart.upgradeEndsAt = value;
}
/**
 * @private 
 */
public function get upgradeEndsAt() : Date
{
   return upgradePart.upgradeEndsAt;
}