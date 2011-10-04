package models.infoscreen
{
   import components.infoscreen.UnitBuildingInfoEntry;
   
   import config.Config;
   
   import controllers.objects.ObjectClass;
   
   import flash.events.Event;
   
   import models.BaseModel;
   import models.unit.ReachKind;
   
   import mx.collections.ArrayCollection;
   
   import utils.MathUtil;
   import utils.ModelUtil;
   import utils.StringUtil;
   import utils.locale.Localizer;
   
   
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
      
      public function getBestTargets(lvl: int, mod: Number): ArrayCollection
      {
         var armors: Array = getBestArmors();
         return getTargets(armors, lvl, mod);
      }
      
      private function getTargets(armors: Array, lvl: int, mod: Number): ArrayCollection
      {
         var targets: ArrayCollection = new ArrayCollection();
         for each (var armor: String in armors)
         {
            targets.addAll(getTargetsWithArmor(armor, lvl, mod));
         }
         return targets;
      }
      
      private function getTargetsWithArmor(armor: String, lvl: int, mod: Number): ArrayCollection
      {
         if (armor == ArmorTypes.FORTIFIED && (reach == ReachKind.GROUND || reach == ReachKind.BOTH))
         {
            return new ArrayCollection(buildBuildingEntries(Config.getAllBuildingsTypes(), lvl, mod));
         }
         else
         {
            return new ArrayCollection(buildUnitEntries(Config.getUnitsWithArmor(armor, reach), lvl, mod));
         }
      }
      
      private function buildBuildingEntries(types: Array, lvl: int, mod: Number): Array
      {
         for (var i: int = 0; i < types.length; i++)
         {
            types[i] = new UnitBuildingInfoEntry(
               ModelUtil.getModelType(ObjectClass.BUILDING, types[i]),
               Localizer.string('Buildings', StringUtil.underscoreToCamelCase(types[i]) + '.name'),
               getDamagePerTick(lvl),
               damage,
               ArmorTypes.FORTIFIED,
               mod
            );
         }
         return types;
      }
      
      private function buildUnitEntries(types: Array, lvl: int, mod: Number): Array
      {
         for (var i: int = 0; i < types.length; i++)
         {
            types[i] = new UnitBuildingInfoEntry(
               ModelUtil.getModelType(ObjectClass.UNIT, types[i]),
               Localizer.string('Units', StringUtil.underscoreToCamelCase(types[i]) + '.name'),
               getDamagePerTick(lvl),
               damage,
               Config.getUnitArmorType(StringUtil.underscoreToCamelCase(types[i])), mod
            );
         }
         return types;
      }
      
      private function getBestArmors(): Array
      {
         var armors: Array = [];
         var coef: Number = 0;
         
         function checkArmor(armorType: String): void
         {
            var tempCoef: Number = getCoef(armorType);
            if (tempCoef > coef)
            {
               coef = tempCoef;
               armors = [];
               armors.push(armorType);
            }
            else if (tempCoef == coef)
            {
               armors.push(armorType);
            }
         }
         
         checkArmor(ArmorTypes.FORTIFIED);
         checkArmor(ArmorTypes.HEAVY);
         checkArmor(ArmorTypes.LIGHT);
         checkArmor(ArmorTypes.NORMAL);
         return armors;
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
         return Localizer.string('InfoScreen', 'damage.' + damage);
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
         return Localizer.string('InfoScreen', 'reach.'+ reach);
      }
      
      public function Gun(_gunType: String, _gunDpt: String, _period: int, _damageType: String, _gunReach: String)
      {
         type = _gunType;
         dpt = _gunDpt;
         period = _period;
         damage = _damageType;
         reach = _gunReach;
      }
      
      public static function getDamageCoefToArmor(damageType: String, armorType: String): Number
      {
         return ((Config.getDamageMultipliers(damageType)[armorType]) as Number);
      }
      
      [Bindable (event = "damageTypeChanged")]
      private function getPercentages(): Object
      {
         return Config.getDamageMultipliers(damage);
      }
      
      [Bindable (event = "damageTypeChanged")]
      public function getPercentage(armorType: String, techMod: Number = 0): String
      {
         return MathUtil.round(((getPercentages()[armorType]) as Number) * (1 + (techMod/100)) * 100, 2).toString() + '%';
      }
      
      public function getCoef(armorType: String): Number
      {
         return ((getPercentages()[armorType]) as Number);
      }
      
      [Bindable (event = "damageTypeChanged")]
      public function getDamage(armorType: String, level: int = 1, mod: Number = 0): String
      {
         return Math.round(((getPercentages()[armorType]) as Number) * (1 + (mod/100)) * getDamagePerTick(level)).toString();
      }
      
      [Bindable (event = "gunTypeChanged")]
      public function get title(): String
      {
         return Localizer.string('InfoScreen', 'gun.'+type);
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