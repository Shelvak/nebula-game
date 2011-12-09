package components.menus
{
   import components.gameobjects.planet.IRPlayerPlanet;
   
   import controllers.ui.NavigationController;
   
   import models.solarsystem.MSSObject;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;

   import spark.components.DropDownList;
   
   import utils.locale.Localizer;
   
   
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
      }
      
      
      /**
       * Typed alias for <code>dataProvider</code> property.
       */
      protected function get planets() : ArrayCollection
      {
         return ArrayCollection(dataProvider);
      }

      private function refreshPrompt(e: CollectionEvent = null): void
      {
         if (e == null || e.kind == CollectionEventKind.ADD
                 || e.kind == CollectionEventKind.REMOVE
                 || e.kind == CollectionEventKind.RESET)
         {
            if (dataProvider != null && dataProvider.length > 0)
            {
               prompt = Localizer.string("SSObjects", "prompt.selectPlanet");
               enabled = true;
            }
            else
            {
               prompt = Localizer.string('Players', 'label.noPlanets');
               enabled = false;
            }
         }
      }

      public override function set dataProvider(value: IList): void
      {
         if (dataProvider != null)
         {
            dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,
               refreshPrompt)
         }
         super.dataProvider = value;
         if (dataProvider != null)
         {
            dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,
               refreshPrompt)
         }
         refreshPrompt();
      }
      
      protected override function itemSelected(index:int, selected:Boolean) : void
      {
         super.itemSelected(index, selected);
         if (selected && index >= 0)
         {
            navigateToPlanet(MSSObject(planets.getItemAt(index)));
            selectedIndex = -1;
         }
      }
      
      
      /**
       * Navigates the map to the given planet. Sets <code>ModelLocator.latestSolarSystem</code>
       * to <code>planet.solarSystem</code>
       * 
       * @param planet a planet to navigate to
       */
      protected function navigateToPlanet(planet:MSSObject) : void
      {
         NavigationController.getInstance().toPlanet(planet);
      }
   }
}