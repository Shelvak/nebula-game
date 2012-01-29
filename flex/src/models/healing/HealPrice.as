package models.healing
{
   import models.ModelLocator;
   import models.building.Building;
   import models.building.BuildingType;
   import models.parts.Upgradable;
   import models.parts.UpgradableType;
   import models.resource.ResourceType;
   import models.solarsystem.MSSObject;
   import models.technology.Technology;
   import models.unit.MCUnit;
   import models.unit.Unit;

   [Bindable]
   public class HealPrice
   {
      public static const HEALING_COST_MOD: String = 'healing.cost.mod';
      public static const HEALING_TIME_MOD: String = 'healing.time.mod';

      public var metal: Number = 0;
      public var energy: Number = 0;
      public var zetium: Number = 0;
      public var cooldown: int = 0;

      public static function calculateRepairPrice(building: Building): HealPrice
      {
         var price: HealPrice = new HealPrice();
         var tech: Technology = ModelLocator.getInstance().technologies.
            getTechnologyByType(Technology.BUILDING_REPAIR);
         var priceMod : Number = tech.repairPriceMod;
         var cooldownMod: Number = tech.repairCooldownMod;
         
         function calcRes(resource: String): Number {
            return Math.round(Upgradable.calculateCost(
               UpgradableType.BUILDINGS, building.type, resource, {'level': 1}
            ) * priceMod * building.damagePercentage);
         } 
         price.metal = calcRes(ResourceType.METAL);
         price.energy = calcRes(ResourceType.ENERGY);
         price.zetium = calcRes(ResourceType.ZETIUM);

         price.cooldown = Math.max(
            1, Math.round((building.hpMax - building.hp) * cooldownMod)
         );

         return price;
      }
      
      
      public static function calculateHealingPrice(units: Array, level: int = 1, 
                                                   type: String = BuildingType.HEALING_CENTER): HealPrice
      {
         var price: HealPrice = new HealPrice();
         var priceMod : Number = Upgradable.evalUpgradableFormula(UpgradableType.BUILDINGS, type, 
                                 'healing.cost.mod', {'level': level});
         var cooldownMod: Number = Upgradable.evalUpgradableFormula(UpgradableType.BUILDINGS, type,
                        'healing.time.mod', {'level': level});
         for each (var mUnit: MCUnit in units)
         {
            var unit: Unit = mUnit.unit;
            price.metal += Math.round(Upgradable.calculateCost(UpgradableType.UNITS, unit.type, 
               ResourceType.METAL, {}) * priceMod * unit.damagePercentage);
            price.energy += Math.round(Upgradable.calculateCost(UpgradableType.UNITS, unit.type, 
               ResourceType.ENERGY, {}) * priceMod * unit.damagePercentage);
            price.zetium += Math.round(Upgradable.calculateCost(UpgradableType.UNITS, unit.type, 
               ResourceType.ZETIUM, {}) * priceMod * unit.damagePercentage);
            price.cooldown += Math.round((unit.hpMax - unit.hp) * cooldownMod);
         }
         price.cooldown = Math.max(1, price.cooldown);
         return price;
      }
      
      /**
       * Adds given price, if there is enough resources in given SSObject,
       * returns true if added and false otherwise
       * @param price - price to add
       * @param planet - ssobject which resources to check
       * @return if these resources were added
       * 
       */      
      public function addIfPossible(price: HealPrice): Boolean
      {
         var planet: MSSObject = ModelLocator.getInstance().latestPlanet.ssObject;
         if (price.metal + metal > planet.metal.currentStock ||
            price.energy + energy > planet.energy.currentStock ||
            price.zetium + zetium > planet.zetium.currentStock)
         {
            return false;
         }
         else
         {
            addPrice(price);
            return true;
         }
      }
      
      private function addPrice(price: HealPrice): void
      {
         metal += price.metal;
         energy += price.energy;
         zetium += price.zetium;
      }
      
      public function substract(price: HealPrice): void
      {
         metal -= price.metal;
         energy -= price.energy;
         zetium -= price.zetium;
      }
      
      public function validate(): Boolean
      {
         var planet: MSSObject = ModelLocator.getInstance().latestPlanet.ssObject;
         if (metal > planet.metal.currentStock ||
            energy > planet.energy.currentStock ||
            zetium > planet.zetium.currentStock)
         {
            return false;
         }
         else
         {
            return true;
         }
      }
   }
}