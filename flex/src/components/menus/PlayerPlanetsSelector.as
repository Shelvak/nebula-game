package components.menus
{
   import components.skins.itemrenderers.IRPlanet;
   
   import controllers.planets.PlanetsCommand;
   import controllers.ui.NavigationController;
   
   import models.ModelLocator;
   import models.map.MapType;
   import models.planet.Planet;
   
   import mx.collections.ArrayCollection;
   import mx.core.ClassFactory;
   
   import spark.components.DropDownList;
   
   
   [ResourceBundle("Planets")]
   
   
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
         itemRenderer = new ClassFactory(components.skins.itemrenderers.IRPlanet);
         prompt = resourceManager.getString("Planets", "prompt.selectPlanet");
      }
      
      
      /**
       * Typed alias for <code>dataProvider</code> property.
       */
      protected function get planets() : ArrayCollection
      {
         return dataProvider as ArrayCollection;
      }
      
      
      protected override function itemSelected(index:int, selected:Boolean) : void
      {
         super.itemSelected(index, selected);
         if (selected && index >= 0)
         {
            navigateToPlanet(planets.getItemAt(index) as Planet);
            selectedIndex = -1;
         }
      }
      
      
      /**
       * Navigates the map to the given planet. Sets <code>ModelLocator.latestSolarSystem</code>
       * to <code>planet.solarSystem</code>
       * 
       * @param planet a planet to navigate to
       */
      protected function navigateToPlanet(planet:Planet) : void
      {
         NavigationController.getInstance().toPlanet(planet);
      }
   }
}