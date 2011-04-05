package components.map.planet
{
   import com.developmentarc.core.utils.EventBroker;
   
   import components.map.planet.objects.BuildingPlaceholder;
   import components.map.planet.objects.IInteractivePlanetMapObject;
   import components.map.planet.objects.IPrimitivePlanetMapObject;
   import components.map.planet.objects.MapBuilding;
   import components.map.planet.objects.PlanetObjectBasement;
   import components.map.planet.objects.PlanetObjectBasementColor;
   import components.popups.ActionConfirmationPopup;
   
   import config.Config;
   
   import controllers.Messenger;
   import controllers.buildings.BuildingsCommand;
   import controllers.buildings.actions.MoveActionParams;
   import controllers.screens.SidebarScreens;
   import controllers.screens.SidebarScreensSwitch;
   
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   
   import flashx.textLayout.formats.LineBreak;
   
   import globalevents.GBuildingEvent;
   import globalevents.GBuildingMoveEvent;
   import globalevents.GSelectConstructableEvent;
   
   import models.ModelLocator;
   import models.building.Building;
   import models.building.BuildingType;
   import models.building.Extractor;
   import models.planet.Planet;
   import models.planet.events.PlanetEvent;
   import models.tile.Tile;
   import models.tile.TileKind;
   
   import mx.collections.ArrayCollection;
   
   import spark.components.Button;
   import spark.components.Label;
   
   import utils.locale.Localizer;
   
   
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
            indicator.x = map.coordsTransform.logicalToReal_X(t.x, lyMax);
            indicator.y = map.coordsTransform.logicalToReal_Y(lxMax, lyMax);
            indicator.depth = Number.MIN_VALUE; // must be below all other objects
            indicator.alpha = 0.3;
            indicator.visible = false;
            _resourceTilesIndicators[t.hashKey()] = indicator;
            objectsLayer.addElement(indicator);
         }
      }
      
      
      public override function cleanup():void
      {
         if (objectsLayer != null && _resourceTilesIndicators != null)
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
                                               t.y + Building.GAP_BETWEEN + 1,
                                               _buildingPH.getBuilding()))
               {
                  indicator.color = PlanetObjectBasementColor.BUILDING_RESTRICTED;
               }
               else
               {
                  indicator.color = PlanetObjectBasementColor.BUILDING_OK;
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
         EventBroker.subscribe(GSelectConstructableEvent.BUILDING_SELECTED, global_buildingSelectedHandler);
         EventBroker.subscribe(GBuildingEvent.MOVE_INIT, global_moveInitHandler);
         EventBroker.subscribe(GBuildingEvent.MOVE_CONFIRM, global_moveConfirmHandler);
         EventBroker.subscribe(GBuildingEvent.MOVE_CANCEL, global_moveCancelHandler);
         EventBroker.subscribe(KeyboardEvent.KEY_DOWN, global_keyDownHandler);
      }
      
      
      override protected function removeGlobalEventHandlers() : void
      {
         EventBroker.unsubscribe(GSelectConstructableEvent.BUILDING_SELECTED, global_buildingSelectedHandler);
         EventBroker.unsubscribe(GBuildingEvent.MOVE_INIT, global_moveInitHandler);
         EventBroker.unsubscribe(GBuildingEvent.MOVE_CONFIRM, global_moveConfirmHandler);
         EventBroker.unsubscribe(GBuildingEvent.MOVE_CANCEL, global_moveCancelHandler);
         EventBroker.unsubscribe(KeyboardEvent.KEY_DOWN, global_keyDownHandler);
         super.removeGlobalEventHandlers();
      }
      
      
      private function global_keyDownHandler(event:KeyboardEvent) : void
      {
         if (event.keyCode == Keyboard.ESCAPE)
         {
            if (_buildingMoveProcessStarted && !_waitingUserConfirmationForMove)
            {
               cancelBuildingMoveProcess(true, false);
            }
         }
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
         if (_buildingProcessStarted)
         {
            commitBuildingProcess();
         }
         else if (_buildingMoveProcessStarted)
         {
            commitBuildingMoveProcess();
         }
      }
      
      
      protected override function addPlanetEventHandlers(planet:Planet) : void
      {
         planet.addEventListener(PlanetEvent.BUILDING_MOVE, planet_buildingMoveHandler, false, 0, true);
      }
      
      
      protected override function removePlanetEventHandlers(planet:Planet) : void
      {
         planet.removeEventListener(PlanetEvent.BUILDING_MOVE, planet_buildingMoveHandler, false);
      }
      
      
      /* ######################## */
      /* ### BUILDING PROCESS ### */
      /* ######################## */
      
      
      private var _buildingPH:BuildingPlaceholder = null;
      private var _deselectMsg:String = Localizer.string('BuildingSidebar', 'pressEsc');
      private var _buildingProcessStarted:Boolean = false;
      
      
      /**
       * This event is received from <code>BuildingSidebar</code> when user selects
       * a building to build.
       */
      private function global_buildingSelectedHandler(event:GSelectConstructableEvent) : void
      {
         if (_buildingMoveProcessStarted)
         {
            objectsLayer.deselectSelectedObject();
            cancelBuildingMoveProcess(false, false);
         }
         if (event.building == null)
         {
            if (_buildingProcessStarted)
            {
               cancelBuildingProcess();
            }
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
         _buildingProcessStarted = true;
         initBuildingPH(building);
      }
      
      
      /**
       * Cancels building process if one has been started. 
       */
      private function cancelBuildingProcess() : void
      {
         _buildingProcessStarted = false;
         destroyBuildingPH();
         Messenger.hide();
      }
      
      
      /**
       * Commits building process: dispatches event, cancels building process
       * and resets all buildings' states to default. 
       */
      private function commitBuildingProcess() : void
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
      
      
      /* ######################## */
      /* ### MOVEMENT PROCESS ### */
      /* ######################## */
      
      
      private var _buildingMoveProcessStarted:Boolean = false;
      private var _waitingUserConfirmationForMove:Boolean = false;
      private var _oldX:int;
      private var _oldY:int;
      
      
      private function global_moveInitHandler(event:GBuildingEvent) : void
      {
         startBuildingMoveProcess(event.building);
      }
      
      
      private function global_moveConfirmHandler(event:GBuildingEvent) : void
      {
         confirmBuildingMoveProcess();
      }
      
      
      private function global_moveCancelHandler(event:GBuildingEvent) : void
      {
         cancelBuildingMoveProcess(false, true);
      }
      
      
      private function startBuildingMoveProcess(building:Building) : void
      {
         cancelBuildingMoveProcess(false, false);
         _buildingMoveProcessStarted = true;
         _waitingUserConfirmationForMove = false;
         _oldX = building.x;
         _oldY = building.y;
         initBuildingPH(building);
      }
      
      
      private function commitBuildingMoveProcess() : void
      {
         var b:Building = _buildingPH.getBuilding();
         if ((b.x != _oldX || b.y != _oldY) && planet.canBeBuilt(b))
         {
            // ask for user confirmation before sending message to the server
            _waitingUserConfirmationForMove = true;
            var popup:ActionConfirmationPopup = new ActionConfirmationPopup();
            popup.title = Localizer.string("Popups", "title.moveBuilding");
            popup.cancelButtonClickHandler = movePopup_cancelButtonHandler;
            popup.confirmButtonClickHandler = movePopup_confirmButtonHandler;
            var lblMessage:Label = new Label();
            lblMessage.text = Localizer.string("Popups", "message.moveBuilding", [Config.getBuildingMoveCost()]);
            lblMessage.setStyle("lineBreak", LineBreak.TO_FIT);
            lblMessage.width = 200;
            popup.addElement(lblMessage);
            popup.show();
         }
         else
         {
            cancelBuildingMoveProcess(true, false);
         }
      }
      
      
      private function movePopup_confirmButtonHandler(button:Button) : void
      {
         _waitingUserConfirmationForMove = false;
         var b:Building = _buildingPH.getBuilding();
         var newX:int = b.x;
         var newY:int = b.y;
         // planet.moveBuilding() accepts building still at its old location
         b.moveTo(_oldX, _oldY);
         planet.moveBuilding(b, newX, newY);
         new BuildingsCommand(
            BuildingsCommand.MOVE,
            new MoveActionParams(b, newX, newY)
         ).dispatch();
      }
      
      
      private function movePopup_cancelButtonHandler(button:Button) : void
      {
         _waitingUserConfirmationForMove = false;
         cancelBuildingMoveProcess(true, false);
      }
      
      
      private function confirmBuildingMoveProcess() : void
      {
         _buildingMoveProcessStarted = false;
         _waitingUserConfirmationForMove = false;
         destroyBuildingPH();
      }
      
      
      /**
       * Cancels move process either after some user action or action denial received from the server.
       * 
       * @param dispatchEvent if <code>true</code>, <code>GBuildingEvent.MOVE_CANCEL</code> event will
       * be dispatched.
       * @param rollback if <code>true</code>, this means that modifications to <code>Planet</code>
       * have been made which have to be rolled back, if <code>false</code> - no modifications to
       * <code>Planet</code> have been made and only current location of the <code>Building</code>
       * moved has to be restored.
       */
      private function cancelBuildingMoveProcess(dispatchEvent:Boolean, rollback:Boolean) : void
      {
         if (!_buildingMoveProcessStarted)
         {
            return;
         }
         _buildingMoveProcessStarted = false;
         _waitingUserConfirmationForMove = false;
         var b:Building = _buildingPH.getBuilding();
         if (rollback)
         {
            planet.moveBuilding(b, _oldX, _oldY);
         }
         else
         {
            b.moveTo(_oldX, _oldY);
         }
         destroyBuildingPH();
         if (dispatchEvent)
         {
            new GBuildingEvent(GBuildingEvent.MOVE_CANCEL, b);
         }
      }
      
      
      private function planet_buildingMoveHandler(event:PlanetEvent) : void
      {
         objectsLayer.positionObject(objectsLayer.getObjectByModel(event.object));
      }
      
      
      /* ################################## */
      /* ### PLACEHOLDER AND MAP UPDATE ### */
      /* ################################## */
      
      
      private function initBuildingPH(building:Building) : void
      {
         Messenger.show(_deselectMsg);
         
         objectsLayer.passOverMouseEventsTo(this);
         
         building.moveTo(-1, -1);
         
         _buildingPH = new BuildingPlaceholder();
         _buildingPH.initModel(building);
         _buildingPH.depth = Number.MAX_VALUE;
         _buildingPH.visible = false;
         
         objectsLayer.addObject(_buildingPH, false);
         if (building.isExtractor)
         {
            showResourceTilesIndicators(Extractor(building).baseResource);
         }
         if (!_buildingMoveProcessStarted)
         {
            objectsLayer.deselectSelectedObject();
         }
         objectsLayer.resetAllInteractiveObjectsState();
         positionBuildingPH();
      }
      
      
      private function destroyBuildingPH() : void
      {
         // TODO i got NPE at objectsLayer.takeOverMouseEvents(); so, i add null check
         if (objectsLayer != null)
         {
            if (_buildingPH != null)
            {
               if (_buildingPH.getBuilding().isExtractor)
               {
                  hideAllResourceTilesIndicators();
               }
               objectsLayer.removeElement(_buildingPH);
               _buildingPH.cleanup();
               _buildingPH = null;
            }
            objectsLayer.takeOverMouseEvents();
            objectsLayer.resetAllInteractiveObjectsState();
         }
      }
      
      
      /**
       * Moves building placeholder to a tile under the mouse and updates associated building model
       * accordingly.
       * 
       * <p>Calls <code>updateBuildingPHState()</code> and
       * <code>makeOverlappingBuildingsTransp()</code> if position has actually been
       * changed.</p>
       */
      private function positionBuildingPH() : void
      {
         var b:Building = _buildingPH.getBuilding();
         var lc:Point = map.coordsTransform.realToLogical(new Point(objectsLayer.mouseX, objectsLayer.mouseY));
         
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
         var b:Building = _buildingPH.getBuilding();
         var tiles:Vector.<Vector.<Boolean>> = _buildingPH.interferingTiles;
         var gap:int   = Building.GAP_BETWEEN;
         var xFrom:int = b.x    - gap;
         var xTo:int   = b.xEnd + gap;
         var yFrom:int = b.y    - gap;
         var yTo:int   = b.yEnd + gap;
         for (var lx:int = xFrom; lx <= xTo; lx++)
         {
            for (var ly:int = yFrom; ly <= yTo; ly++)
            {
               // tiles under the building
               if (b.standsOn(lx, ly))
               {
                  tiles[lx - xFrom][ly - yFrom] =
                     ! planet.isOnMap(lx, ly) ||
                       b.isTileRestricted(planet.getTile(lx, ly)) ||
                       planet.buildingsInAreaExist(lx, lx, ly, ly, b) ||
                       planet.blockingFolliagesInAreaExist(lx, lx, ly, ly);
               }
               // tiles around the building
               else
               {
                  var border:int = PlanetMap.BORDER_SIZE;
                  tiles[lx - xFrom][ly - yFrom] =
                     !  planet.isOnMap(lx, ly)
                     && (lx < -border || lx > planet.width  + border - 1 ||
                         ly < -border || ly > planet.height + border - 1)
                     || planet.isOnMap(lx, ly) && planet.buildingsInAreaExist(lx, lx, ly, ly, b);
               }
            }
         }
         _buildingPH.applyInterferingTiles();
      }
      
      
      private function dispatchBuildingMoveEvent(building:Building) : void
      {
         new GBuildingMoveEvent(GBuildingMoveEvent.MOVE, planet.getTilesUnderBuilding(building), building);
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
         if (!_buildingMoveProcessStarted)
         {
            SidebarScreensSwitch.getInstance().showPrevious();
         }
      }
      
      
      /* ######################### */
      /* ### OPENNING BUILDING ### */
      /* ######################### */
      
      
      protected override function openObjectImpl(object:IPrimitivePlanetMapObject) : void
      {
         var buildingC:MapBuilding = MapBuilding(object);
         if (!buildingC.getBuilding().isGhost)
         {
            new GBuildingEvent(GBuildingEvent.OPEN, Building(buildingC.model));
         }
      }
   }
}
