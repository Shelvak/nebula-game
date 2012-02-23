package models.technology
{
   import config.Config;
   
   import controllers.objects.ObjectClass;

   import flash.events.Event;

   import globalevents.GTechnologiesEvent;
   
   import models.BaseModel;
   import models.parts.events.UpgradeEvent;
   import models.technology.events.TechnologyEvent;
   
   import mx.collections.ArrayCollection;
   
   import utils.StringUtil;
   
   [Bindable]
   public class TechnologiesModel extends BaseModel
   {
      public static const TECH_ALLIANCES:String = "Alliances";
      
      
      private var coordsHash: Object;
      private var techsHash: Object;
      
      public var technologies:ArrayCollection = new ArrayCollection();
      
      public function clean(): void
      {
         for each (var tech:Technology in technologies)
         {
            tech.cleanup();
         }
         technologies.removeAll();
         _buildingRepairTechnology = null;
         coordsHash = null;
         techsHash = null;
      }
      
      public function createAllTechnologies(): void
      {
         coordsHash = new Object();
         techsHash = new Object();
         mods = {};
         nullMods = null;
         for each (var tech: String in Config.getTechnologiesTypes())
         createTechnology(tech);
         new GTechnologiesEvent(GTechnologiesEvent.TECHNOLOGIES_CREATED);
         startConstructions();
      }
      
      private function startConstructions(): void
      {
         for each (var tech: Technology in technologies)
         {
            if (tech.upgradePart.upgradeEndsAt != null)
               tech.upgradePart.startUpgrade();
         }
      }
      
      public function createTechnology(type: String):void {
         var temp: Technology = new Technology();
         temp.type = type;
         if (temp.groupTo == null)
         {
            coordsHash[getCoordsAsString(temp.coords[0], temp.coords[1])] = true;
         }
         techsHash[type] = temp;
         temp.dispatchEvent(new Event(TechnologyEvent.TECHNOLOGY_CREATED));
         technologies.addItem(temp);
      }
      
      private var mods: Object = {};
      private var nullMods: Object;
      
      [Bindable (event="technologyChanged")]
      /**
       * 
       * @param property type of technology modifier 
       * @see models.resource.ModType for property types
       * @return Number value of property modifier in percent
       * 
       */      
      public function getTechnologiesPropertyMod(property: String, applies: String = null): Number
      {
         var value: Number = 0;
         var _mods: Object;
         if (applies == null)
         {
            if (nullMods == null)
            {
               nullMods = Config.getTechnologiesMods(applies);
            }
            _mods = nullMods;
         }
         else
         {
            if (mods[applies] == null)
            {
               mods[applies] = Config.getTechnologiesMods(applies);
            }
            _mods = mods[applies];
         }
         for (var key: String in _mods)
         {
            if (_mods[key][property] != null)
            {
               var currentTech: Technology = getTechnologyByType(StringUtil.underscoreToCamelCase(key));
               if (currentTech.level > 0)
                  value += StringUtil.evalFormula(_mods[key][property], {'level': currentTech.level});
            }
         }
         return value;
      }
      
      [Bindable (event="technologyChanged")]
      /**
       * 
       * @param type - unit type
       * @param level - unit level
       * @return how much storage can this unit store
       * 
       */      
      public function getUnitStorage(type: String, level: int): int
      {
         var formula: String = Config.getUnitStorage(type);
         if (formula == null) return 0;

         var rawStorage: Number = Math.round(
            StringUtil.evalFormula(formula, {'level': level})
         );
         var mod: Number = 1.0 + getTechnologiesPropertyMod(
            'storage',
            ObjectClass.UNIT + '/' + StringUtil.camelCaseToUnderscore(type)
         ) / 100.0;

         return Math.round(rawStorage * mod);
      }
      
      private static function getCoordsAsString(x:int, y:int): String
      {
         return x.toString() + "," + y.toString();
      }
      
      public function isFree(x: int, y: int): Boolean
      {
         return coordsHash[getCoordsAsString(x, y)];
      }

      private var _buildingRepairTechnology:Technology = null;
      [Bindable (event="repairBuildingChanged")]
      public function get buildingRepairTechnology() : Technology {
         if (_buildingRepairTechnology == null) {
            _buildingRepairTechnology = getTechnologyByType(Technology.BUILDING_REPAIR);
            _buildingRepairTechnology.addEventListener
               (UpgradeEvent.LEVEL_CHANGE,
                       buildingRepairTechnologyLvlChangeHandler, false, 0, true);
         }
         return _buildingRepairTechnology;
      }

      [Bindable (event="repairBuildingChanged")]
      public function get hasBuildingRepairTechnology() : Boolean {
         return buildingRepairTechnology.level > 0;
      }
      
      public function getTechnologyById(tech_id: int): Technology
      {
         if (techsHash[tech_id] == null)
         {
            for each (var element: Technology in technologies)
               if (element.id == tech_id) techsHash[tech_id] = element;
         }
         return techsHash[tech_id];
      }
      
      public function getTechnologyByType(tech_type: String): Technology
      {
         return techsHash[StringUtil.underscoreToCamelCase(tech_type)];
      }

      private function buildingRepairTechnologyLvlChangeHandler(e: UpgradeEvent): void
      {
         if (hasEventListener(TechnologyEvent.REPAIR_BUILDING_LEVEL_CHANGED))
         {
            dispatchEvent(new TechnologyEvent(
                    TechnologyEvent.REPAIR_BUILDING_LEVEL_CHANGED));
         }
      }
      
      public function dispatchTechsChangeEvent(): void
      {
         if (hasEventListener(TechnologyEvent.TECHNOLOGY_CHANGED))
         {
            mods = {};
            nullMods = null;
            dispatchEvent(new TechnologyEvent(TechnologyEvent.TECHNOLOGY_CHANGED));
         }
      }
      
   }
}