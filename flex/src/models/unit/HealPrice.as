package models.unit
{
   import models.building.BuildingType;
   import models.parts.Upgradable;
   import models.parts.UpgradableType;
   import models.resource.ResourceType;

   [Bindable]
   public class HealPrice
   {
      public var metal: Number = 0;
      public var energy: Number = 0;
      public var zetium: Number = 0;
      public var cooldown: int = 0;
      
      
      public static function calculateHealingPrice(units: Array, level: int = 1, 
                                                   type: String = BuildingType.HEALING_CENTER): HealPrice
      {
         var price: HealPrice = new HealPrice();
         var priceMod : Number = Upgradable.evalUpgradableFormula(UpgradableType.BUILDINGS, type, 
                                 'healing.cost.mod', {'level': level});
         var cooldownMod: Number = Upgradable.evalUpgradableFormula(UpgradableType.BUILDINGS, type,
                        'healing.time.mod', {'level': level});
         for each (var unit: Unit in units)
         {
            price.metal += Math.round(Upgradable.calculateCost(UpgradableType.UNITS, unit.type, 
               ResourceType.METAL, {}) * priceMod * unit.damagePercentage);
            price.energy += Math.round(Upgradable.calculateCost(UpgradableType.UNITS, unit.type, 
               ResourceType.ENERGY, {}) * priceMod * unit.damagePercentage);
            price.zetium += Math.round(Upgradable.calculateCost(UpgradableType.UNITS, unit.type, 
               ResourceType.ZETIUM, {}) * priceMod * unit.damagePercentage);
            price.cooldown += Math.round((unit.hpMax - unit.hp) * cooldownMod);
         }
         return price;
      }
   }
}