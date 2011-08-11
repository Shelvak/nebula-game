package models.resource
{
   import config.Config;
   
   import models.BaseModel;
   import models.ModelLocator;
   import models.Reward;
   import models.building.Building;
   import models.parts.Upgradable;
   import models.parts.UpgradableType;
   import models.planet.MBoost;
   import models.resource.events.ResourcesEvent;
   import models.solarsystem.MSSObject;
   import models.unit.Unit;
   
   import mx.collections.ArrayCollection;
   
   import utils.MathUtil;
   import utils.StringUtil;
   import utils.locale.Localizer;
   
   [Bindable]
   public class Resource extends BaseModel
   {
      public var type: String = "";
      private var _currentStock: Number = 0;
      private var _maxStock: Number = 0;
      private var _generationRate: Number = 0;
      private var _usageRate: Number = 0;
      
      public static function getMissingStoragesString(planet: MSSObject,
                                              metalCost: Number, 
                                              energyCost: Number, 
                                              zetiumCost: Number,
                                              credsCost: Number = 0): String
      {
         var missingStorages: Array = [];
         if (ML.latestPlanet)
         {
            var planet:MSSObject = ML.latestPlanet.ssObject;
            if (metalCost  > planet.metal.maxStock)
            {
               missingStorages.push(ResourceType.METAL);
            }
            if (energyCost  > planet.energy.maxStock)
            {
               missingStorages.push(ResourceType.ENERGY);
            }
            if (zetiumCost  > planet.zetium.maxStock)
            {
               missingStorages.push(ResourceType.ZETIUM);
            }
            var tempStorageString: String = '';
            var i: int = 0;
            for each (var res: String in missingStorages)
            {
               if (i > 0)
               {
                  if (i == missingStorages.length - 1)
                  {
                     tempStorageString += ' '+Localizer.string('Resources', 'and')+' ';
                  }
                  else
                  {
                     tempStorageString += ', ';
                  }
               }
               i++;
               tempStorageString += Localizer.string('Resources', 'additionalStorage.resource', [res]);
            }
            return tempStorageString;
         }
         return '';
      }
      
      public static function getNotFittingResourcesString(planet: MSSObject,
                                                          metal: Number, 
                                                          energy: Number, 
                                                          zetium: Number): String
      {
         var missingStorages: Array = [];
         var missingAmounts: Array = [];
         var tempStorageString: String = '';
         if (metal + planet.metal.currentStock > planet.metal.maxStock)
         {
            missingStorages.push(ResourceType.METAL);
            missingAmounts.push(metal + planet.metal.currentStock - planet.metal.maxStock);
         }
         if (energy + planet.energy.currentStock > planet.energy.maxStock)
         {
            missingStorages.push(ResourceType.ENERGY);
            missingAmounts.push(energy + planet.energy.currentStock - planet.energy.maxStock);
         }
         if (zetium + planet.zetium.currentStock > planet.zetium.maxStock)
         {
            missingStorages.push(ResourceType.ZETIUM);
            missingAmounts.push(zetium + planet.zetium.currentStock - planet.zetium.maxStock);
         }
         if (missingStorages.length == 0)
         {
            return null;
         }
         else
         {
            var i: int = 0;
            for each (var res: String in missingStorages)
            {
               if (i > 0)
               {
                  if (i == missingStorages.length - 1)
                  {
                     tempStorageString += ' '+Localizer.string('Resources', 'and')+' ';
                  }
                  else
                  {
                     tempStorageString += ', ';
                  }
               }
               tempStorageString += MathUtil.round(missingAmounts[i], 2).toString();
               i++;
               tempStorageString += ' '+Localizer.string('Resources', 'wontFit.resource', [res]);
            }
            return tempStorageString;
         }
      }
      
      /**
       * 
       * @param planet
       * @param reward
       * @return String - message to display and null if planet or reward 
       * not given or reward fits
       * 
       */      
      public static function getNotFittingReward(planet: MSSObject, reward: Reward): String
      {
         
         if (reward && planet)
         {
            return getNotFittingResourcesString(planet, reward.metal, 
               reward.energy, reward.zetium);
         }
         else
         {
            return null;
         }
      }
      
      public static function getTimeToReachResources(currentMetal: Resource, currentEnergy: Resource, currentZetium: Resource,
                                                     destMetal: int, destEnergy: int, destZetium: int): int
      {
         if (currentMetal.currentStock  >= destMetal &&
            currentEnergy.currentStock >= destEnergy &&
            currentZetium.currentStock >= destZetium)
            return 0
         else if (((currentMetal.rate <= 0) && (currentMetal.currentStock < destMetal)) || 
            ((currentEnergy.rate <= 0) && (currentEnergy.currentStock < destEnergy)) || 
            ((currentZetium.rate <= 0) && (currentZetium.currentStock < destZetium)))
            return -1
         else
         {
            var tempMetalReach: int = currentMetal.currentStock >= destMetal?0:
               Math.ceil((destMetal - currentMetal.currentStock)/currentMetal.rate);
            var tempEnergyReach: int = currentEnergy.currentStock >= destEnergy?0:
               Math.ceil((destEnergy - currentEnergy.currentStock)/currentEnergy.rate);
            var tempZetiumReach: int = currentZetium.currentStock >= destZetium?0:
               Math.ceil((destZetium - currentZetium.currentStock)/currentZetium.rate);
            
            var tempMetalLose: int = currentMetal.rate >= 0?int.MAX_VALUE:
               -1*Math.ceil((currentMetal.currentStock - destMetal)/currentMetal.rate);
            var tempEnergyLose: int = currentEnergy.rate >= 0?int.MAX_VALUE:
               -1*Math.ceil((currentEnergy.currentStock - destEnergy)/currentEnergy.rate);
            var tempZetiumLose: int = currentZetium.rate >= 0?int.MAX_VALUE:
               -1*Math.ceil((currentZetium.currentStock - destZetium)/currentZetium.rate);
            
            if (Math.max(tempMetalReach, tempEnergyReach, tempZetiumReach) > 
               Math.min(tempMetalLose, tempEnergyLose, tempZetiumLose))
               return -1
            else
               return Math.max(tempMetalReach, tempEnergyReach, tempZetiumReach);
         }
      }
      
      public static function calculateNewResources(source: Number, volumeLoaded: int, resource: String): Number
      {
         var tSource: Number = source;
         var tVolume: int = volumeLoaded;
         if (tSource % Config.getResourceVolume(resource) > 0)
         {
            if (tVolume < 0)
            {
               tSource = int(source / Config.getResourceVolume(resource)) * Config.getResourceVolume(resource);
               tVolume--;
            }
            else if (tVolume > 0)
            {
               tSource = int(source / Config.getResourceVolume(resource)) * Config.getResourceVolume(resource);
               tVolume++;
            }
            else
            {
               return (int(source / Config.getResourceVolume(resource)) + 1) * Config.getResourceVolume(resource);
            }
         }
         return tSource + getResourcesForVolume(tVolume, resource);
      }
      
      public static function calculateUnitDestructRevenue(units: ArrayCollection, resource: String): Number
      {
         var revenue: Number = 0;
         var gain: int = Config.getUnitDestructResourceGain();
         for each (var unit: Unit in units)
         {
            if (resource == ResourceType.POPULATION)
            {
               revenue += Config.getUnitPopulation(unit.type);
            }
            else
            {
               revenue += (Upgradable.calculateCost(UpgradableType.UNITS, unit.type, resource, {})*
                  unit.alivePercentage * (gain/100));
            }
         }
         return Math.round(revenue);
      }
      
      public static function calculateBuildingDestructRevenue(type: String, level: int, resource: String): Number
      {
         var revenue: Number = 0;
         var gain: int = Config.getBuildingDestructResourceGain();
         for (var i: int = 1; i <= level; i++)
         {
            revenue += Upgradable.calculateCost(UpgradableType.BUILDINGS, type, resource, {'level': i});
         }
         return Math.round(revenue * gain/100);
      }
      
      public static function getResourcesVolume(metal: Number, energy: Number, zetium: Number): int
      {
         return getResourceVolume(metal, ResourceType.METAL) + getResourceVolume(energy, ResourceType.ENERGY)
            + getResourceVolume(zetium, ResourceType.ZETIUM);
      }
      
      public static function getResourceVolume(amount: Number, resourceType: String): int
      {
         return Math.ceil(amount / Config.getResourceVolume(resourceType));
      }
      
      public static function getResourcesForVolume(volume: int, resourceType: String): Number
      {
         return volume * Config.getResourceVolume(resourceType);
      }
      
      public var boost: MBoost = new MBoost();
      
      [Bindable (event="resourceStorageChanged")]
      public function get maxStock(): Number
      {
         return _maxStock * ModelLocator.getInstance().resourcesMods.getStorageMod(type)
            * boost.getStorageBoost();
      }
      
      [Bindable (event="resourceRateChanged")]
      public function get rate(): Number
      {
         return _generationRate * ModelLocator.getInstance().resourcesMods.getRateMod(type)
            * boost.getRateBoost() - _usageRate;
      }
      
      public function set maxStock(value: Number): void
      {
         _maxStock = value;
         dispatchStorageChangeEvent();
      }
      
      public function set usageRate(value: Number): void
      {
         _usageRate = value;
         dispatchRateChangeEvent();
      }
      
      public function set generationRate(value: Number): void
      {
         _generationRate = value;
         dispatchRateChangeEvent();
      }
      
      
      public function Resource(name: String = ""):void{
         type = name;
      }
      
      public function set currentStock(value: Number): void
      {
         _currentStock = value;
         dispatchStockChangeEvent();
      }
      
      [Bindable (event="resourceAmmountChanged")]
      public function getWithoutTaxes(taxRate: Number): Number
      {
         return Math.floor(_currentStock / (1 + taxRate));
      }
      
      [Bindable (event="resourceAmmountChanged")]
      public function get currentStock(): Number
      {
         return _currentStock;
      }
      
      private function dispatchStockChangeEvent(): void
      {
         if (hasEventListener(ResourcesEvent.RESOURCES_CHANGED))
         {
            dispatchEvent(new ResourcesEvent(ResourcesEvent.RESOURCES_CHANGED));
         }
      }
      
      private function dispatchStorageChangeEvent(): void
      {
         if (hasEventListener(ResourcesEvent.STORAGE_CHANGED))
         {
            dispatchEvent(new ResourcesEvent(ResourcesEvent.STORAGE_CHANGED));
         }
      }
      
      private function dispatchRateChangeEvent(): void
      {
         if (hasEventListener(ResourcesEvent.RATE_CHANGED))
         {
            dispatchEvent(new ResourcesEvent(ResourcesEvent.RATE_CHANGED));
         }
      }
      
      public function renewAllInfoDueToModsChange(): void
      {
         dispatchStockChangeEvent();
         dispatchStorageChangeEvent();
         dispatchRateChangeEvent();
      }
      
      
      public override function toString():String
      {
         return "[class: " + CLASS + ", type: " + type + ", rate: " + rate +
            ", currentStock: " + currentStock + ", maxStock: " + maxStock + "]";
      }
      
      
      public override function equals(o:Object):Boolean
      {
         if (!super.equals(o))
         {
            return false;
         }
         var resource:Resource = Resource(o);
         return type == resource.type &&
            rate == resource.rate &&
            currentStock == resource.currentStock &&
            maxStock == resource.maxStock;
      }
   }
}