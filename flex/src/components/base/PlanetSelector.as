package components.base
{
   import components.skins.itemrenderers.IRPlanet;
   
   import models.solarsystem.MSSObject;
   
   import mx.core.ClassFactory;
   
   import spark.components.DropDownList;
   
   import utils.locale.Localizer;
   
   
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
            return MSSObject(item).name;
         }
         selectedIndex = 0;
         requireSelection = true;
         itemRenderer = new ClassFactory(components.skins.itemrenderers.IRPlanet);
         prompt = Localizer.string("SSObjects", "prompt.selectPlanet");
      }
   }
}