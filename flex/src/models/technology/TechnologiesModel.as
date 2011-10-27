package models.technology
{
   import config.Config;
   
   import controllers.objects.ObjectClass;
   
   import globalevents.GTechnologiesEvent;
   
   import models.BaseModel;
   import models.technology.events.TechnologyEvent;
   
   import mx.collections.ArrayCollection;
   
   import utils.StringUtil;
   
   [Bindable]
   public class TechnologiesModel extends BaseModel
   {
      public static const TECH_ALLIANCES:String = "Alliances";
      
      
      private var coordsHash: Object;
      
      public var technologies:ArrayCollection = new ArrayCollection();
      
      public function clean(): void
      {
         for each (var tech:Technology in technologies)
         {
            tech.cleanup();
         }
         technologies.removeAll();
         coordsHash = null;
      }
      
      public function createAllTechnologies(): void
      {
         coordsHash = new Object();
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
         coordsHash[getCoordsAsString(temp.coords[0], temp.coords[1])] = true; 
         temp.dispatchEvent(new Event(TechnologyEvent.TECHNOLOGY_CREATED));
         technologies.addItem(temp);
      }
      
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
         var mods: Object = Config.getTechnologiesMods(applies);
         for (var key: String in mods)
         {
            if (mods[key][property] != null)
            {
               var currentTech: Technology = getTechnologyByType(StringUtil.underscoreToCamelCase(key));
               if (currentTech.level > 0)
                  value += StringUtil.evalFormula(mods[key][property], {'level': currentTech.level});
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
         return Math.round(Math.round(StringUtil.evalFormula(Config.getUnitStorage(type), 
            {'level': level})) * ((100 +
         getTechnologiesPropertyMod('storage', 
            ObjectClass.UNIT + '/' + StringUtil.camelCaseToUnderscore(type))) / 100));
      }
      
      private static function getCoordsAsString(x:int, y:int): String
      {
         return x.toString() + "," + y.toString();
      }
      
      public function isFree(x: int, y: int): Boolean
      {
         return coordsHash[getCoordsAsString(x, y)];
      }
      
      public function getTechnologyById(tech_id: int): Technology
      {
         for each (var element: Technology in technologies)
         if (element.id == tech_id) return element;
         return null;
      }
      
      public function getTechnologyByType(tech_type: String): Technology
      {
         for each (var element: Technology in technologies)
         if (element.type == StringUtil.underscoreToCamelCase(tech_type)) return element;
         return null;
      }
      
      public function dispatchTechsChangeEvent(): void
      {
         dispatchEvent(new TechnologyEvent(TechnologyEvent.TECHNOLOGY_CHANGED));
      }
      
   }
}