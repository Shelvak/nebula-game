package models.battle
{
   import config.BattleConfig;
   

   public class BProjectileSpeed
   {
      public static function getDelay(gunType:String) : Number
      {
         return BattleConfig.getGunDelay(gunType); 
      }
      
      
      public static function getSpeed(gunType:String) : Number
      {
         return BattleConfig.getGunSpeed(gunType); 
      }
   }
}