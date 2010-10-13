package components.map.planet
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.gameobjects.building.MapBuilding;
   import components.gameobjects.building.NewBuildingPlaceholder;
   import components.gameobjects.planet.IInteractivePlanetMapObject;
   import components.gameobjects.planet.IPrimitivePlanetMapObject;
   
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import globalevents.GBuildingEvent;
   import globalevents.GBuildingMoveEvent;
   import globalevents.GSelectConstructableEvent;
   
   import models.ModelLocator;
   import models.building.Building;
   import models.factories.BuildingFactory;
   
   
   /**
    * Dispatched from <code>EventBroker</code> while user is moving new building
    * around the map and as a result tiles under the building are changing.
    * <p><code>building</code> property is set to the new building that is beeing
    * moved.</p> 
    * 
    * @eventType globalevents.GBuildingMoveEvent.MOVE 
    */
   [Event (name="move", type="globalevents.GBuildingMoveEvent")]
   
   /**
    * Dispatched from <code>EventBroker</code> when user clicks on an empty
    * space on the map to start construction of a building.
    * <p><code>building</code> property of event object is set to the instance
    * of a building that must be constructed.</p> 
    * 
    * @eventType globalevents.GBuildingEvent.CONSTRUCTION_COMMIT 
    */
   [Event (name="constructionCommit", type="globalevents.GBuildingEvent")]
   
   
   public class BuildingsLayer extends PlanetVirtualLayer
   {
      override protected function get componentClass() : Class
      {
         return MapBuilding;
      }
      
      
      override protected function get modelClass() : Class
      {
         return Building;
      }
      
      
      protected override function get objectsListName() : String
      {
         return "buildings";
      }
      
      
      /* ###################### */
      /* ### EVENT HANDLERS ### */
      /* ###################### */
      
      override public function handleMouseEvent(event:MouseEvent) : void
      {
         switch (event.type)
         {
            case MouseEvent.MOUSE_OVER:
               this_mouseOverHandler(event);
               break;
            
            case MouseEvent.MOUSE_OUT:
               this_mouseOutHandler(event);
               break;
            
            case MouseEvent.MOUSE_MOVE:
               this_mouseMoveHandler(event);
               objectsLayer.redispatchEventFromMap(event);   // For map drag to work
               break;
            
            case MouseEvent.CLICK:
               this_clickHandler(event);
               break;
            
            case MouseEvent.MOUSE_DOWN:
            case MouseEvent.MOUSE_UP:
               objectsLayer.redispatchEventFromMap(event);   // For map drag to work
               break;
         }
      }
      
      
      override protected function addGlobalEventHandlers() : void
      {
         super.addGlobalEventHandlers();
         EventBroker.subscribe(
            GSelectConstructableEvent.BUILDING_SELECTED,
            buildingSidebar_buildingSelectedHandler
         );
      }
      
      
      override protected function removeGlobalEventHandlers() : void
      {
         super.removeGlobalEventHandlers();
         EventBroker.unsubscribe(
            GSelectConstructableEvent.BUILDING_SELECTED,
            buildingSidebar_buildingSelectedHandler
         );
      }
      
      
      private function this_mouseOutHandler(e:MouseEvent) : void
      {
         positionBuildingPH();
      }
      
      
      private function this_mouseOverHandler(e:MouseEvent) : void
      {
         positionBuildingPH();
      }
      
      
      private function this_mouseMoveHandler(e:MouseEvent) : void
      {
         positionBuildingPH();
      }
      
      
      private function this_clickHandler(e:MouseEvent) : void
      {
         commitBuilding();
      }
      
      
      /* ############################## */
      /* ### BUILDING PROCESS STUFF ### */
      /* ############################## */
      
      /**
       * Indicates if building process is suspended: that means new building placeholder is not
       * visible and mouse is not over the BuildingsLayer component. 
       */      
      private var fBuildingSuspended:Boolean = false;
      
      private var buildingPH:NewBuildingPlaceholder = null;
      
      /**
       * This event is received from <code>BuildingSidebar</code> when user selects
       * a building to build.
       */
      private function buildingSidebar_buildingSelectedHandler(event:GSelectConstructableEvent) : void
      {
         if (event.building == null)
         {
            cancelBuildingProcess();
         }
         else
         {
            startBuildingProcess(event.building);
         }
      }
      
      /**
       * Starts the procees of building new structure on the map.
       * 
       * @param type Type of new building. 
       */      
      private function startBuildingProcess(building:Building) : void
      {
         cancelBuildingProcess();
         objectsLayer.passOverMouseEventsTo(this);
         
         building.moveTo(-1, -1);
         
         buildingPH = new NewBuildingPlaceholder();
         buildingPH.initModel(building);
         
         objectsLayer.addObject(buildingPH, false);
         
         objectsLayer.deselectSelectedObject();
         objectsLayer.resetAllInteractiveObjectsState();
         positionBuildingPH();
      }
      
      /**
       * Cancels building process if one has been started. 
       */      
      private function cancelBuildingProcess() : void
      {
         if (buildingPH)
         {
            objectsLayer.removeElement(buildingPH);
            buildingPH.cleanup();
            buildingPH = null;
         }
         objectsLayer.takeOverMouseEvents();
         objectsLayer.resetAllInteractiveObjectsState();
      }
      
      /**
       * Commits building process: dispatches event, cancels building process
       * and resets all buildings' state to default. 
       */      
      private function commitBuilding() : void
      {
         if (planet.canBeBuilt(buildingPH.getBuilding()))
         {
            new GBuildingEvent(GBuildingEvent.CONSTRUCTION_COMMIT, buildingPH.getBuilding());
         }
         else
         {
            new GBuildingEvent(GBuildingEvent.CONSTRUCTION_CANCEL);
         }
         cancelBuildingProcess(); 
      }
      
      /**
       * Moves building placeholder to a tile under the mouse and updates associated
       * building model accordingly. If the mouse is not other map, hides the placeholder.
       * 
       * <p>Calls <code>updateBuildingPHState()</code>,
       * <code>recalculateNewBuildingBonuses()</code> and
       * <code>makeOverlappingBuildingsTransp()</code> if position has actually been
       * changed.</p>
       */      
      private function positionBuildingPH() : void
      {
         var building:Building = buildingPH.getBuilding();
         var moved:Boolean = false;
         
         // Update model coordinates
         var lc:Point = map.getLogicalTileCoords(objectsLayer.mouseX, objectsLayer.mouseY);
         if (lc != null)
         {
            moved = building.moveTo(lc.x, lc.y);
         }
         else
         {
            moved = building.moveTo(-1, -1);
         }
         
         // Don't do anything if building has not been moved.
         if (!moved)
         {
            return;
         }
         
         // Now update component
         if (planet.isBuildingOnMap(building))
         {
            buildingPH.visible = true;
            objectsLayer.positionObject(buildingPH);
            dispatchBuildingMoveEvent(building);
            updateBuildingPHState();
            makeOverlappingObjectsTransp();
         }
         else
         {
            buildingPH.visible = false;
         }
      }
      
      /**
       * Updates building placeholder state.
       */      
      private function updateBuildingPHState() : void
      {
         if (planet.canBeBuilt(buildingPH.getBuilding()))
         {
            buildingPH.restrictBuilding = false;
         }
         else
         {
            buildingPH.restrictBuilding = true;
         }
      }
      
      private function dispatchBuildingMoveEvent(building:Building) : void
      {
         new GBuildingMoveEvent(
            GBuildingMoveEvent.MOVE,
            planet.getTilesUnderBuilding(building),
            building
         );
      }
      
      /**
       * Makes any existing buildings around the placeholder transparent in order
       * a user could be able to see tiles behind those buildings.
       */      
      private function makeOverlappingObjectsTransp() : void
      {
         objectsLayer.resetAllInteractiveObjectsState();
         for each (var object:IInteractivePlanetMapObject in objectsLayer.getOverlappingObjects(buildingPH))
         {
            object.faded = true;
         }
      }
      
      
      /* ######################################## */
      /* ### BUILDING SELECTION / DESELECTION ### */
      /* ######################################## */
      
      
      protected override function objectSelectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ModelLocator.getInstance().selectedBuilding = Building(object.model);
         SidebarScreensSwitch.getInstance().showScreen(SidebarScreens.BUILDING_SELECTED);
      }
      
      
      protected override function objectDeselectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ModelLocator.getInstance().selectedBuilding = null;
         SidebarScreensSwitch.getInstance().showPrevious();
      }
      
      
      /* ######################### */
      /* ### OPENNING BUILDING ### */
      /* ######################### */
      
      
      protected override function openObjectImpl(object:IPrimitivePlanetMapObject) : void
      {
         var buildingC:MapBuilding = MapBuilding(object);
         new GBuildingEvent(GBuildingEvent.OPEN, Building(buildingC.model));
      }
   }
}
