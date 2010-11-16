package models.infoscreen
{
   import config.Config;
   
   import flash.events.Event;
   
   import models.BaseModel;
   import models.unit.UnitBuildingEntry;
   
   import mx.collections.ArrayCollection;
   
   import utils.StringUtil;
   
   [ResourceBundle ('infoScreen')]
   
   [Bindable]
   public class Gun extends BaseModel
   {
      
      
      private var _type: String;
      
      /**
       * Gun type 
       */      
      public function set type(value: String): void
      {
         _type = value;
      }
      
      [Bindable (event = "gunTypeChanged")]
      public function get type(): String
      {
         return _type;
      }
      
      private var _dpt: String;
      
      /**
       * Damage per tick 
       */      
      public function set dpt(value: String): void
      {
         _dpt = value;
         dispatchDptChangeEvent();
      }
      
      /**
       * marks if this gun are grouped (for info screen) 
       */      
      public var count: int = 1;
      
      public override function hashKey():String
      {
         return _type+','+_dpt+','+period+','+damage+','+reach;
      }
      
      public function getDamagePerTick(level: int = 1, mod: Number = 0): Number
      {
         return StringUtil.evalFormula(_dpt, {'level': level}) * (1+(mod/100));
      }
      
      [Bindable (event='dptChanged')]
      public function getDamagePerTickString(level: int = 1, mod: Number = 0): String
      {
         return Math.round(StringUtil.evalFormula(_dpt, {'level': level}) * (1+(mod/100))).toString();
      }
      
      public function getBestTargets(): ArrayCollection
      {
         return new ArrayCollection([new UnitBuildingEntry('unit::Trooper'), new UnitBuildingEntry('building::Mothership')]);
      }
      
      
      /**
       * Cooldown time
       */      
      public var period: int;
      
      private var _damage: String;
      
      /**
       * Damage type 
       */      
      public function set damage(value: String):void
      {
         _damage = value;
         dispatchDamageTypeChangeEvent();
      }
      
      [Bindable (event = "damageTypeChanged")]
      public function get damage(): String
      {
         return _damage;
      }
      
      [Bindable (event = "damageTypeChanged")]
      public function get damageTitle(): String
      {
         return RM.getString('infoScreen', 'damage.' + damage);
      }
      
      
      private var _reach: String;
      
      /**
       * Reach kind 
       */      
      public function set reach(value: String):void
      {
         _reach = value;
         dispatchReachChangeEvent();
      }
      
      [Bindable (event = "reachChanged")]
      public function get reach(): String
      {
         return _reach;
      }
      
      [Bindable (event = "reachChanged")]
      public function get reachTitle(): String
      {
         return RM.getString('infoScreen', 'reach.'+ reach);
      }
      
      public function Gun(_gunType: String, _gunDpt: String, _period: int, _damageType: String, _gunReach: String)
      {
         type = _gunType;
         dpt = _gunDpt;
         period = _period;
         damage = _damageType;
         reach = _gunReach;
      }
      
      [Bindable (event = "damageTypeChanged")]
      private function getPercentages(): Object
      {
         return Config.getDamageMultiplyers(damage);
      }
      
      [Bindable (event = "damageTypeChanged")]
      public function getPercentage(armorType: String): String
      {
         return (((getPercentages()[armorType]) as Number) * 100).toString() + '%';
      }
      
      public function getCoef(armorType: String): Number
      {
         return ((getPercentages()[armorType]) as Number);
      }
      
      [Bindable (event = "damageTypeChanged")]
      public function getDamage(armorType: String, level: int = 1, mod: Number = 0): String
      {
         return Math.round((((getPercentages()[armorType]) as Number) + (mod/100)) * getDamagePerTick(level)).toString();
      }

      [Bindable (event = "gunTypeChanged")]
      public function get title(): String
      {
         return RM.getString('infoScreen', 'gun.'+type);
      }
      
      private function dispatchDptChangeEvent(): void
      {
         if (hasEventListener("dptChanged"))
         {
            dispatchEvent(new Event("dptChanged"));
         }
      }
      
      private function dispatchGunTypeChangeEvent(): void
      {
         if (hasEventListener("gunTypeChanged"))
         {
            dispatchEvent(new Event("gunTypeChanged"));
         }
      }
      
      private function dispatchReachChangeEvent(): void
      {
         if (hasEventListener("reachChanged"))
         {
            dispatchEvent(new Event("reachChanged"));
         }
      }
      
      private function dispatchDamageTypeChangeEvent(): void
      {
         if (hasEventListener("damageTypeChanged"))
         {
            dispatchEvent(new Event("damageTypeChanged"));
         }
      }
   }
}