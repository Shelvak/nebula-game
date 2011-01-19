package models.battle
{
   import config.BattleConfig;
   
   import flash.geom.Point;
   
   import models.BaseModel;
   
   public class BGun extends BaseModel
   {
      public var type:String = BGunType.MACHINE_GUN;
      
      
      public var position:Point = null;
      
      
      public function get kind(): String
      {
         return BattleConfig.getGunAnimationProps(type).kind
      }
      
      
      public function get shotDelay() : Number
      {
         return BProjectile.getDelay(type);
      }
      
      
      public function get shots() : int
      {
         return BattleConfig.getGunAnimationProps(type).shots;
      }
      
      
      public function get dispersion() : int
      {
         return BattleConfig.getGunAnimationProps(type).dispersion;
      }
      
      public function playFireSound(): void
      {
         var soundName: String = ((Math.random() * 500 + (Math.random() * 10)) * Math.random()).toString();
      }
   }
}