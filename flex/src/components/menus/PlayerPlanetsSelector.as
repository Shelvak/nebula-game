package components.menus
{
   import components.gameobjects.planet.IRPlayerPlanet;
   
   import controllers.ui.NavigationController;
   
   import models.solarsystem.SSObject;
   
   import mx.collections.ArrayCollection;
   import mx.core.ClassFactory;
   
   import spark.components.DropDownList;
   
   import utils.Localizer;
   
   
   /**
    * List that holds all planets that belong to the player.
    */
   public class PlayerPlanetsSelector extends DropDownList
   {
      /**
       * Constructor.
       */
      public function PlayerPlanetsSelector()
      {
         super();
         requireSelection = false;
         itemRenderer = new ClassFactory(IRPlayerPlanet);
         prompt = Localizer.string("SSObjects", "prompt.selectPlanet");
      }
      
      
      /**
       * Typed alias for <code>dataProvider</code> property.
       */
      protected function get planets() : ArrayCollection
      {
         return ArrayCollection(dataProvider);
      }
      
      
      protected override function itemSelected(index:int, selected:Boolean) : void
      {
         super.itemSelected(index, selected);
         if (selected && index >= 0)
         {
            navigateToPlanet(SSObject(planets.getItemAt(index)));
            selectedIndex = -1;
         }
      }
      
      
      /**
       * Navigates the map to the given planet. Sets <code>ModelLocator.latestSolarSystem</code>
       * to <code>planet.solarSystem</code>
       * 
       * @param planet a planet to navigate to
       */
      protected function navigateToPlanet(planet:SSObject) : void
      {
         NavigationController.getInstance().toPlanet(planet);
      }
   }
}