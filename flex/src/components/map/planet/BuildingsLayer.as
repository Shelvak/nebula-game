package components.map.planet
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.gameobjects.building.MapBuilding;
   import components.gameobjects.building.NewBuildingPlaceholder;
   import components.gameobjects.planet.IInteractivePlanetMapObject;
   import components.gameobjects.planet.IPrimitivePlanetMapObject;
   import components.gameobjects.planet.PlanetObjectBasement;
   
   import controllers.Messenger;
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   import globalevents.GBuildingEvent;
   import globalevents.GBuildingMoveEvent;
   import globalevents.GSelectConstructableEvent;
   
   import models.ModelLocator;
   import models.building.Building;
   import models.building.BuildingType;
   import models.building.Extractor;
   import models.planet.Planet;
   import models.tile.Tile;
   import models.tile.TileKind;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.Group;
   
   import utils.Localizer;
   
   
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
      private var ML:ModelLocator = ModelLocator.getInstance();
      private var SSS:SidebarScreensSwitch = SidebarScreensSwitch.getInstance();
      
      
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
      
      
      /* ################################# */
      /* ### RESOURCE TILES INDICATORS ### */
      /* ################################# */
      
      
      private var _resourceTilesIndicators:Object;
      private var _resourceTiles:ArrayCollection;
      
      
      public override function initialize(objectsLayer:PlanetObjectsLayer, map:PlanetMap, planet:Planet) : void
      {
         super.initialize(objectsLayer, map, planet);
         _resourceTilesIndicators = new Object();
         _resourceTiles = planet.resourceTiles;
         var lw:int = Extractor.WIDTH;
         var lh:int = Extractor.HEIGHT;
         for each (var t:Tile in _resourceTiles)
         {
            var indicator:PlanetObjectBasement = new PlanetObjectBasement();
            var lxMax:int = t.x + lw - 1;
            var lyMax:int = t.y + lh - 1;
            indicator.logicalWidth = lw;
            indicator.logicalHeight = lh;
            indicator.x = map.getRealTileX(t.x, lyMax);
            indicator.y = map.getRealTileY(lxMax, lyMax);
            indicator.depth = Number.MIN_VALUE; // must be below all other objects
            indicator.alpha = 0.3;
            indicator.visible = false;
            _resourceTilesIndicators[t.hashKey()] = indicator;
            objectsLayer.addElement(indicator);
         }
      }
      
      
      public override function cleanup():void
      {
         if (objectsLayer && _resourceTilesIndicators)
         {
            for each (var indicator:PlanetObjectBasement in _resourceTilesIndicators)
            {
               objectsLayer.removeElement(indicator);
            }
            _resourceTiles = null;
            _resourceTilesIndicators = null;
         }
         super.cleanup();
      }
      
      
      private function hideAllResourceTilesIndicators() : void
      {
         for each (var indicator:PlanetObjectBasement in _resourceTilesIndicators)
         {
            indicator.visible = false;
         }
      }
      
      
      private function showResourceTilesIndicators(kind:int) : void
      {
         for each (var t:Tile in _resourceTiles)
         {
            if (t.kind == kind)
            {
               var indicator:PlanetObjectBasement = _resourceTilesIndicators[t.hashKey()];
               if (planet.buildingsInAreaExist(t.x - Building.GAP_BETWEEN,
                  t.x - Building.GAP_BETWEEN + 1,
                  t.y + Building.GAP_BETWEEN,
                  t.y + Building.GAP_BETWEEN + 1))
               {
                  indicator.setStyle("chromeColor", 0xFF0000);
               }
               else
               {
                  indicator.setStyle("chromeColor", 0x00FF00);
               }
               indicator.visible = true;
            }
         }
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
         EventBroker.unsubscribe(
            GSelectConstructableEvent.BUILDING_SELECTED,
            buildingSidebar_buildingSelectedHandler
         );
         super.removeGlobalEventHandlers();
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
      
      
      private var _buildingPH:NewBuildingPlaceholder = null;
      private var _newBuilding:Building = null;
      
      private var deselectMsg: String = Localizer.string('BuildingSidebar', 'pressEsc');
      
      /**
       * This event is received from <code>BuildingSidebar</code> when user selects
       * a building to build.
       */
      private function buildingSidebar_buildingSelectedHandler(event:GSelectConstructableEvent) : void
      {
         if (event.building == null)
         {
            if (buildingProcessStarted)
            {
               cancelBuildingProcess();
               Messenger.hide();
               buildingProcessStarted = false;
            }
         }
         else
         {
            startBuildingProcess(event.building);
            Messenger.show(deselectMsg);
            buildingProcessStarted = true;
         }
         
      }
      
      private var buildingProcessStarted: Boolean = false;
      
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
         
         _newBuilding = building;
         _buildingPH = new NewBuildingPlaceholder();
         _buildingPH.initModel(building);
         _buildingPH.depth = Number.MAX_VALUE;
         _buildingPH.visible = false;
         
         objectsLayer.addObject(_buildingPH, false);
         if (_newBuilding.isExtractor)
         {
            var tileKind:int
            switch (_newBuilding.type)
            {
               case BuildingType.METAL_EXTRACTOR: tileKind = TileKind.ORE; break;
               case BuildingType.ZETIUM_EXTRACTOR: tileKind = TileKind.ZETIUM; break;
               case BuildingType.GEOTHERMAL_PLANT: tileKind = TileKind.GEOTHERMAL; break;
            }
            showResourceTilesIndicators(tileKind);
         }
         
         objectsLayer.deselectSelectedObject();
         objectsLayer.resetAllInteractiveObjectsState();
         positionBuildingPH();
      }
      
      /**
       * Cancels building process if one has been started. 
       */
      private function cancelBuildingProcess() : void
      {
         //TODO i got NPE at objectsLayer.takeOverMouseEvents(); so, i add null check
         if (objectsLayer != null)
         {
            if (_buildingPH)
            {
               objectsLayer.removeElement(_buildingPH);
               _buildingPH.cleanup();
               _buildingPH = null;
               if (_newBuilding.isExtractor)
               {
                  hideAllResourceTilesIndicators();
               }
               _newBuilding = null;
            }
            objectsLayer.takeOverMouseEvents();
            objectsLayer.resetAllInteractiveObjectsState();
         }
      }
      
      /**
       * Commits building process: dispatches event, cancels building process
       * and resets all buildings' state to default. 
       */
      private function commitBuilding() : void
      {
         if (planet.canBeBuilt(_buildingPH.getBuilding()))
         {
            new GBuildingEvent(GBuildingEvent.CONSTRUCTION_COMMIT, _buildingPH.getBuilding());
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
         var b:Building = _buildingPH.getBuilding();
         var lc:Point = map.getLogicalTileCoords(objectsLayer.mouseX, objectsLayer.mouseY, false);
         
         // Don't do anything if building has not been moved.
         if (!b.moveTo(lc.x, lc.y))
         {
            return;
         }
         
         _buildingPH.visible = true;
         objectsLayer.positionObject(_buildingPH);
         dispatchBuildingMoveEvent(b);
         updateBuildingPHState();
         makeOverlappingObjectsTransp();
      }
      
      /**
       * Updates building placeholder state.
       */
      private function updateBuildingPHState() : void
      {
         if (planet.canBeBuilt(_buildingPH.getBuilding()))
         {
            _buildingPH.restrictBuilding = false;
         }
         else
         {
            _buildingPH.restrictBuilding = true;
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
       * a user could be able to see tiles behind and under those buildings.
       */
      private function makeOverlappingObjectsTransp() : void
      {
         objectsLayer.resetAllInteractiveObjectsState();
         for each (var object:IInteractivePlanetMapObject in objectsLayer.getOverlappingObjects(_buildingPH))
         {
            object.faded = true;
         }
      }
      
      
      /* ######################################## */
      /* ### BUILDING SELECTION / DESELECTION ### */
      /* ######################################## */
      
      
      protected override function objectSelectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ML.selectedBuilding = Building(object.model);
         SidebarScreensSwitch.getInstance().showScreen(SidebarScreens.BUILDING_SELECTED);
      }
      
      
      protected override function objectDeselectedImpl(object:IInteractivePlanetMapObject) : void
      {
         ML.selectedBuilding = null;
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
