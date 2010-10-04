import config.BattleConfig;

private var guns:Array = null;
/**
 * Returns a gun with specified id.
 * 
 * @param id id (index) of a gun; starts from 0
 * 
 * @return instance of <code>BGun</code> with a given id
 */
public function getGun(id:int) : BGun
{
   if (!guns)
   {
      guns = BattleConfig.getUnitGuns(type);
   }
   return guns[id];
}