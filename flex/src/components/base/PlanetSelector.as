package components.base
{
   import components.skins.itemrenderers.IRPlanet;
   
   import models.planet.Planet;
   
   import mx.core.ClassFactory;
   
   import spark.components.DropDownList;
   
   
   [ResourceBundle("Planets")]
   
   
   /**
    * List that holds all planets that belong to the player.
    */
   public class PlanetSelector extends DropDownList
   {
      /**
       * Constructor.
       */
      public function PlanetSelector()
      {
         super();
         labelFunction = function myLabelFunction(item:Object):String
         {
            return (item as Planet).name;
         }
         selectedIndex = 0;
         requireSelection = true;
         itemRenderer = new ClassFactory(components.skins.itemrenderers.IRPlanet);
         prompt = resourceManager.getString("Planets", "prompt.selectPlanet");
      }
   }
}