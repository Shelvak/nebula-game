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
   if (upgradePart)
      return upgradePart.level;
   else
      return 0;
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