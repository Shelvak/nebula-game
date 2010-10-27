package components.battle
{
   import components.map.CMap;
   
   import config.BattleConfig;
   
   import controllers.ui.NavigationController;
   
   import flash.display.BitmapData;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Mouse;
   
   import flashx.textLayout.formats.TextAlign;
   
   import models.BaseModel;
   import models.IBattleParticipantModel;
   import models.ModelsCollection;
   import models.Owner;
   import models.battle.BAlliance;
   import models.battle.BBuilding;
   import models.battle.BFlank;
   import models.battle.BOverallHp;
   import models.battle.BUnit;
   import models.battle.Battle;
   import models.battle.BattleMatrix;
   import models.battle.BattleParticipantType;
   import models.battle.PlaceFinder;
   import models.battle.events.BattleControllerEvent;
   import models.tile.TerrainType;
   import models.unit.UnitKind;
   
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.core.FlexGlobals;
   
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.layouts.HorizontalAlign;
   
   import utils.ArrayUtil;
   import utils.assets.AssetNames;
   import utils.assets.ImagePreloader;
   import utils.datastructures.Hash;
   import utils.profiler.Profiler;
   
   
   [ResourceBundle ('BattleMap')]
   
   /**
    * A map of battlefield. Holds background and animation layer with objects.
    */
   public class BattleMap extends CMap
   {
      private static const MAX_IMG_EDGE_LENGHT:Number = 8191;
      private static const MAX_IMG_PIX_COUNT:Number = 16777215;
      //flank offset is added to distance between teams later
      private static const DISTANCE_BETWEEN_TEAMS: Number = 150
      private static const DISTANCE_BETWEEN_TEAMS_IN_CELLS:Number = DISTANCE_BETWEEN_TEAMS/GRID_CELL_WIDTH;
      
      private static const SPACE_HEIGHT:Number = 250;
      private static const GROUND_HEIGHT:Number = 350;
      private static const SPACE_ONLY_HEIGHT:Number = 400;
      private static const GROUND_ONLY_HEIGHT:Number = 350;
      
      public static const GRID_CELL_WIDTH: Number = 10;
      public static const GRID_CELL_HEIGHT: Number = 10;
      
      private static const SPACE_UNITS_VERTICAL_CELLS: Number = Math.floor((SPACE_HEIGHT - 20) / GRID_CELL_HEIGHT);
      private static const SPACE_ONLY_VERTICAL_CELLS: Number = Math.floor((SPACE_ONLY_HEIGHT - 20) / GRID_CELL_HEIGHT);
      
      private static const GROUND_UNITS_VERTICAL_CELLS: Number = Math.floor((GROUND_HEIGHT - 20) / GRID_CELL_HEIGHT);
      private static const GROUND_ONLY_VERTICAL_CELLS: Number = Math.floor((GROUND_ONLY_HEIGHT - 20) / GRID_CELL_HEIGHT);
      
      private static const SPACE_UNITS_TOP: int = Math.ceil(20/GRID_CELL_HEIGHT);
      
      private static const MIN_FOLLIAGE_IN_OFFSET: int = 2;
      private static const MAX_FOLLIAGE_IN_OFFSET: int = 5;
      
      private static const FOLLIAGE_AFTER_UNIT_CHANCE: Number = 0.25; // 1/x
      private static const FOLLIAGE_AFTER_FOLLIAGE_CHANCE: int = 0.1; // 1/x
      
      
      private static const FLANK_OFFSET: Number = 100;
      private static const FLANK_OFFSET_IN_CELLS: int = FLANK_OFFSET/GRID_CELL_WIDTH;
      private static const MAX_FLANK_WIDTH_IN_PIXELS: Number = 300;
      private static const MAX_FLANK_WIDTH: Number = MAX_FLANK_WIDTH_IN_PIXELS/GRID_CELL_WIDTH;
      private static const MAX_BUILDINGS_WIDTH_IN_PIXELS: Number = 400;
      private static const MAX_BUILDINGS_WIDTH: int = MAX_BUILDINGS_WIDTH_IN_PIXELS/GRID_CELL_WIDTH;
      
      
      
      private static function get sceneryHeight() : Number
      {
         return ImagePreloader.getInstance()
            .getImage(AssetNames.getBattlefieldBackgroundImage(BattlefieldBackgroundPart.SCENERY))
            .height;
      }
      
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      
      private var _battle:Battle = null;
      public function getBattle() : Battle
      {
         return _battle;
      }
      
      /**
       * 
       * @param battle
       * 
       */
      private var battleOverlay: Group = new Group();
      public function BattleMap(battle:Battle)
      {
         _battle = battle;
         folliages = new ArrayCollection();
         
         Profiler.clean();
         Profiler.start("total");
         unitsMatrix = new BattleMatrix();
         unitsMatrix.rowCount = rowCount;
         currentCell = new Point(0, 0);
         if (_battle.buildings.length != 0 && (_battle.buildings.getFirstItem() as BBuilding).playerStatus == 0)
         {
            placeFolliages(currentCell.x + 1, currentCell.x + FLANK_OFFSET_IN_CELLS - 1);
            Profiler.start("createBuildings");
            createBuildings(false);
            Profiler.end();
         }
         placeFolliages(currentCell.x + 1, currentCell.x + FLANK_OFFSET_IN_CELLS - 1);
         
         Profiler.start("createUnits");
         createUnits();
         Profiler.end();
         
         if (_battle.buildings.length != 0 && (_battle.buildings.getFirstItem() as BBuilding).playerStatus != 0)
         {
            Profiler.start("createBuildings");
            createBuildings(true);
            Profiler.end();
            placeFolliages(currentCell.x + 1, currentCell.x + FLANK_OFFSET_IN_CELLS - 1);
         }
         
         unitsMatrix.isFree(currentCell, new Point(currentCell.x, 1));
         Profiler.start("calculateSize");
         calculateSize();
         Profiler.end();
         
         Profiler.start("renderBackground");
         renderBackground();
         Profiler.end();
         Profiler.end();
         
         if (Profiler.enabled) 
         {
            FlexGlobals.topLevelApplication.profilerTextArea.text = Profiler.resultsString;
            FlexGlobals.topLevelApplication.profilerTextArea.visible = true;
         }
         super(battle);
      }
      
      public var overallHp: OverallHpPanel = new OverallHpPanel();
      
      protected override function getBackground() : BitmapData
      {
         return _backgroundData;
      }
      
      
      protected override function getSize():Point
      {
         return new Point(totalWidth, totalHeight);
      }
      
      private var paused: Boolean = true;
      
      public var speedLbl: Label = new Label();
      
      public var battleOverLabel: Label = new Label();
      
      public var closeButton: Button = new Button();
      
      protected override function createObjects() : void
      {
         super.createObjects();
         for (var id:String in units)
         {
            if (!contains(units[id]))
               addElement(units[id]);
         }
         for (var key:String in buildings)
         {
            addElement(buildings[key]);
         }
         for (var i: int = 0; i < folliages.length; i++)
         {
            addElement(folliages[i]);
         }
         
         overallHp.right = 3;
         overallHp.top = 3;
         overallHp.width = 300;
         var a: Button = new Button();
         var b: Button = new Button();
         var c: Button = new Button();
         function dispatchTogglePauseEvent(e: MouseEvent): void
         {
            paused = !paused;
            if (paused)
            {
               b.label = "Resume";
            }
            else
            {
               b.label = "Pause";
            }
            dispatchEvent(new BattleControllerEvent(BattleControllerEvent.TOGGLE_PAUSE));
         }
         function dispatchDecreaseSpeedEvent(e: MouseEvent): void
         {
            dispatchEvent(new BattleControllerEvent(BattleControllerEvent.CHANGE_SPEED, false));
         }
         function dispatchIncreaseSpeedEvent(e: MouseEvent): void
         {
            dispatchEvent(new BattleControllerEvent(BattleControllerEvent.CHANGE_SPEED, true));
         }
         a.label = '<<';
         a.addEventListener(MouseEvent.CLICK, dispatchDecreaseSpeedEvent);
         a.top = 3;
         a.right = 306;
         b.label = 'Play';
         b.addEventListener(MouseEvent.CLICK, dispatchTogglePauseEvent);
         b.top = 23;
         b.right = 306;
         c.label = '>>';
         c.addEventListener(MouseEvent.CLICK, dispatchIncreaseSpeedEvent);
         c.top = 43;
         c.right = 306;
         speedLbl.text = '1x';
         speedLbl.top = 66;
         speedLbl.right = 306;
         
         battleOverLabel.horizontalCenter = 0;
         battleOverLabel.verticalCenter = 0;
         battleOverLabel.visible = false;
         battleOverLabel.scaleX = 0;
         battleOverLabel.scaleY = 0;
         battleOverLabel.setStyle('fontSize',54);
         battleOverLabel.setStyle('color',0xeec500);
         battleOverLabel.setStyle('text-align',TextAlign.CENTER);
         battleOverLabel.setStyle('text-align-last',TextAlign.CENTER);
         
         
         function showPrevious(e: MouseEvent): void
         {
            NavigationController.getInstance().showPreviousScreen();
         }
         closeButton.right = 3;
         closeButton.bottom = 3;
         closeButton.label = RM.getString('BattleMap', 'close');
         closeButton.addEventListener(MouseEvent.CLICK, showPrevious);
         
         battleOverlay.addElement(overallHp);
         battleOverlay.addElement(a);
         battleOverlay.addElement(b);
         battleOverlay.addElement(c);
         battleOverlay.addElement(speedLbl);
         battleOverlay.addElement(battleOverLabel);
         battleOverlay.addElement(closeButton);
         this.viewport.overlay = battleOverlay;
         
         //         for each (var line: Line in lines)
         //         {
         //            addElement(line);
         //         }
         /*
         for (i = 0; i < unitsMatrix.rowCount; i++)
         for (var j: int = 0; j < unitsMatrix.columnCount; j++)
         {
         if (unitsMatrix.isOccupied(new Point(j, i)))
         {
         var testRect: Rect = new Rect();
         testRect.x = j*GRID_CELL_WIDTH;
         testRect.width = GRID_CELL_WIDTH;
         testRect.y = i*GRID_CELL_HEIGHT;
         testRect.height = GRID_CELL_HEIGHT;
         testRect.fill = new SolidColor(0x0000ff, 1);
         testRect.alpha = 1;
         addElement(testRect);
         }
         }
         */
      }
      
      
      /* ############ */
      /* ### SIZE ### */
      /* ############ */
      
      
      /**
       * Calculates and returns MAX available width of a map.
       * 
       * @return MAX available width of a map in pixels
       */
      private function getMaxWidth() : Number
      {
         var maxWidth: Number = 0;
         maxWidth += unitsMatrix.columnCount * GRID_CELL_WIDTH;
         return maxWidth;
      }
      
      
      private var totalWidth:Number = 0;
      private var totalHeight:Number = 0;
      private var spaceHeight:Number = 0;
      private var groundHeight:Number = 0;
      private function calculateSize() : void
      {
         groundHeight = _battle.hasSpaceUnitsOnly?0:
            (_battle.hasGroundUnitsOnly?GROUND_ONLY_HEIGHT:GROUND_HEIGHT);
         spaceHeight = _battle.hasGroundUnitsOnly?0:
            (_battle.hasSpaceUnitsOnly?SPACE_ONLY_HEIGHT:SPACE_HEIGHT);
         totalHeight = groundHeight + spaceHeight + (groundHeight == 0 ? 0 : sceneryHeight);
         totalWidth = getMaxWidth();
      }
      
      
      /* ################## */
      /* ### BACKGROUND ### */
      /* ################## */
      
      
      private var _backgroundData:BitmapData = null;
      private function renderBackground() : void
      {
         _backgroundData = new BattlefieldBackgroundRenderer
            (TerrainType.getType(_battle.location.variation), spaceHeight, groundHeight, totalWidth).render();
      }
      
      private function get sceneryCells(): int
      {
         return Math.ceil(sceneryHeight/GRID_CELL_HEIGHT);
      }
      
      private function get groundStart(): int
      {
         return _battle.hasSpaceUnitsOnly?SPACE_ONLY_VERTICAL_CELLS + SPACE_UNITS_TOP:
            (_battle.hasGroundUnitsOnly?sceneryCells:SPACE_UNITS_VERTICAL_CELLS+sceneryCells + SPACE_UNITS_TOP);
      }
      
      private function get spaceUnitsHeight(): int
      {
         return _battle.hasSpaceUnitsOnly?SPACE_ONLY_VERTICAL_CELLS:
            (_battle.hasGroundUnitsOnly?0:SPACE_UNITS_VERTICAL_CELLS);
      }
      
      private function get groundUnitsHeight(): int
      {
         return _battle.hasGroundUnitsOnly?GROUND_ONLY_VERTICAL_CELLS:
            (_battle.hasSpaceUnitsOnly?0:GROUND_UNITS_VERTICAL_CELLS);
      }
      
      private function get rowCount(): int
      {
         return groundStart + groundUnitsHeight;
      }
      
      private function getMiddle(unitKind: String): int
      {
         if (unitKind == UnitKind.GROUND)
         {
            return groundStart + Math.floor(groundUnitsHeight/2);
         }
         else
         {
            return SPACE_UNITS_TOP + Math.floor(spaceUnitsHeight/2);
         }
      }
      
      /* #################### */
      /* ### PARTICIPANTS ### */
      /* #################### */
      
      private function placeFolliages(start: int, end: int): void
      {
         var folliageCount: int = _battle.rand.integer(MIN_FOLLIAGE_IN_OFFSET, MAX_FOLLIAGE_IN_OFFSET+1);
         var finder: PlaceFinder = new PlaceFinder(end - start, groundUnitsHeight-1, _battle.rand);
         for (var i: int = 0; i < folliageCount; i++)
         {
            placeFolliage(finder);
         }
         for each (var folliage: BFoliageComp in preparedObjects)
         { 
            folliage.xGridPos += start;
            folliage.yGridPos += groundStart;
            
            folliage.depth = folliage.yGridPos;
            
            var leftTop: Point = new Point(folliage.xGridPos, folliage.yGridPos);
            var rightBottom: Point = new Point(folliage.getWidthInCells(GRID_CELL_WIDTH) + folliage.xGridPos - 1, 
               folliage.getHeightInCells(GRID_CELL_HEIGHT) + folliage.yGridPos - 1);
            if (unitsMatrix.isFree(leftTop, rightBottom))
            {
               unitsMatrix.occupy(leftTop,rightBottom);
            }
            else
            {
               throw new Error('you have tried to occupy the cell that has already been occupied');
            }
            
            folliage.x = folliage.xGridPos * GRID_CELL_WIDTH
               + (_battle.rand.random() * (GRID_CELL_WIDTH * folliage.getWidthInCells(GRID_CELL_WIDTH) - folliage.width));
            folliage.y = folliage.yGridPos * GRID_CELL_HEIGHT
               + (_battle.rand.random() * (GRID_CELL_HEIGHT * folliage.getHeightInCells(GRID_CELL_HEIGHT) - folliage.height));
         }
         preparedObjects = [];
         currentCell.x += (end - start + 1);
      }
      
      public function getParticipant(type:int, id:int) : BBattleParticipantComp
      {
         var hash:Hash;
         switch(type)
         {
            case BattleParticipantType.UNIT:
               hash = units;
               break;
            case BattleParticipantType.BUILDING:
               hash = buildings;
               break;
         }
         return hash[id];
      }
      
      public function getParticipantModel(type:int, id:int) : *
      {
         var hash: Hash;
         switch(type)
         {
            case BattleParticipantType.UNIT:
               hash = units;
               break;
            case BattleParticipantType.BUILDING:
               hash = buildings;
               break;
         }
         if (hash[id] == null)
            return null;
         return (hash[id] as BBattleParticipantComp).getGroupedParticipantModel(id);
      }
      
      
      
      /* ################# */
      /* ### BUILDINGS ### */
      /* ################# */
      
      
      /**
       * Maps id's to building components. Removing or adding components to this map won't
       * affect display list so you must add or remove components to display list manually.
       */
      private var buildings:Hash = new Hash();
      
      private var buildingsWidth: int = 0;
      
      public function getBuildingWithId(id:int) : BBuildingComp
      {
         return buildings[id];
      }
      
      
      private function createBuildings(flip: Boolean): void
      {
         if (_battle.buildings.length != 0)
         {
            var finder: PlaceFinder = new PlaceFinder(MAX_BUILDINGS_WIDTH, groundUnitsHeight, _battle.rand);
            Profiler.start("shuffle buildings");
            _battle.buildings.shuffle(_battle.rand);
            Profiler.end();
            
            var building: BBuilding;
            var distinctTypes: ArrayCollection = new ArrayCollection();
            var distinctBuildings: ArrayCollection = new ArrayCollection();
            var later: Array = [];
            
            Profiler.start("find distinct buildings");
            for each (building in _battle.buildings)
            {
               if (distinctTypes.getItemIndex(building.type) == -1)
               {
                  distinctTypes.addItem(building.type);
                  distinctBuildings.addItem(building);
               }
               else
               {
                  later.push(building);
               }
            }
            Profiler.end();
            
            Profiler.start("sort distinct buildings");
            distinctBuildings.sort = new Sort();
            distinctBuildings.sort.compareFunction = function (a:Object, b:Object, fields:Array = null):int
            {
               if (a.box.width > b.box.width)
                  return -1;
               else
                  if (a.box.width == b.box.width)
                     return 0;
               return 1;
            }
            distinctBuildings.refresh();
            Profiler.end();
            
            Profiler.start("place distinct buildings");
            for each (building in distinctBuildings)
            {            
               createBuilding(building, finder, flip, true);
            }
            Profiler.end();
            Profiler.start("place other buildings");
            for each (building in later)
            {      
               createBuilding(building, finder, flip); 
            }
            Profiler.end();
            
            
            Profiler.start("refresh prepared objects");
            var xStart: int = finder.getXStartFree();
            var xEnd: int = finder.getXEndFree();
            buildingsWidth = finder.maxWidth - xEnd - xStart;
            for each (var obj: * in preparedObjects)
            {
               obj.xGridPos += (currentCell.x - xStart);
               obj.yGridPos += groundStart;
               var leftTop: Point = new Point(obj.xGridPos, obj.yGridPos);
               var rightBottom: Point = new Point(obj.getWidthInCells(GRID_CELL_WIDTH) + obj.xGridPos - 1, 
                  obj.getHeightInCells(GRID_CELL_HEIGHT) + obj.yGridPos - 1);
               obj.depth = obj.yGridPos;
               if (unitsMatrix.isFree(leftTop, rightBottom))
               {
                  unitsMatrix.occupy(leftTop,rightBottom);
               }
               else
               {
                  throw new Error('you have tried to occupy the cell that has already been occupied');
               }
               obj.x = obj.xGridPos * GRID_CELL_WIDTH
                  + (_battle.rand.random() * (GRID_CELL_WIDTH * obj.getWidthInCells(GRID_CELL_WIDTH) 
                     - obj.boxWidth)) - obj.xOffset;
               obj.y = obj.yGridPos * GRID_CELL_HEIGHT
                  + (_battle.rand.random() * (GRID_CELL_HEIGHT * obj.getHeightInCells(GRID_CELL_HEIGHT) 
                     - obj.boxHeight)) - obj.yOffset;
            }
            currentCell.x += buildingsWidth;
            unitsMatrix.isFree(currentCell, new Point(currentCell.x, 1) );
            preparedObjects = [];
            Profiler.end();
         }
      }
      
      private function createBuilding(building:BBuilding, finder: PlaceFinder, flip: Boolean, distinct: Boolean = false) : void
      {
         Profiler.start("Create building " + building.toString());
         
         Profiler.start('Creating component');
         var buildingComp:BBuildingComp = new BBuildingComp(building);
         if (flip)
         {
            buildingComp.flipHorizontally();
         }
         Profiler.end();
         building.actualHp = building.hp;         
         
         var hpEntry: BOverallHp;
         switch (building.playerStatus)
         {
            case Owner.PLAYER:
               hpEntry = overallHp.selfHp;
               break;
            case Owner.ALLY:
               hpEntry = overallHp.allyHp;
               break;
            case Owner.ENEMY:
               hpEntry = overallHp.enemyHp;
               break;
            case Owner.NAP:
               hpEntry = overallHp.napHp;
               break;
         }
         hpEntry.groundMax += building.maxHp;
         hpEntry.groundCurrent += building.actualHp;
         
         var buildingWidthInCells:int = buildingComp.getWidthInCells(GRID_CELL_WIDTH);
         var buildingHeightInCells:int = buildingComp.getHeightInCells(GRID_CELL_HEIGHT);
         
         var buildingPlace: Point = finder.findPlace(buildingWidthInCells, buildingHeightInCells);
         
         if (buildingPlace == null)
         {
            if (distinct)
            {
               throw new Error('no place for distinct building ' + building.type);
            }
            else
            {
               buildingComp.hidden = true;
               buildings[building.id] = buildingComp;
               groupObject(buildingComp, buildings);
               Profiler.end();
               return;
            }
         }
         else
         {
            buildingComp.xGridPos = buildingPlace.x;
            buildingComp.yGridPos = buildingPlace.y;
            buildings[building.id] = buildingComp;
         }
         preparedObjects.push(buildingComp);
         Profiler.end();
      }
      
      
      public function removeBuildingWithId(id:int) : BBuildingComp
      {
         var buildingToRemove:BBuildingComp = getBuildingWithId(id);
         if (!buildingToRemove)
         {
            return null;
         }
         buildingToRemove.depth = 1;
         buildings.removeValue(buildingToRemove);
         return buildingToRemove;
      }
      
      
      public function removeBuilding(building:BBuildingComp) : BBuildingComp
      {
         if (!building)
         {
            return null;
         }
         return removeBuildingWithId(building.participantModel.id);
      }
      
      
      /* ############# */
      /* ### UNITS ### */
      /* ############# */
      
      
      public function refreshUnits(): void
      {
         for each (var unit: BUnitComp in units)
         {
            unit.handleCreation(_battle.rand);
         }
      }
      
      public function get unitsHash(): Hash
      {
         return units;
      }
      
      /**
       * Maps id's to unit components. Removing or adding components to this map won't
       * affect display list so you must add or remove components to display list manually.
       */
      private var units:Hash = new Hash();
      /**
       * Creates all units and sets their position properties.
       */
      private function createUnits() : void
      {
         if (_battle.isDefenderVsOffender)
         {
            _battle.alliances.sort = new Sort();
            _battle.alliances.sort.compareFunction = function (a:Object, b:Object, fields:Array = null):int
            {
               if (a.status > b.status)
                  return 1;
               else
                  return -1;
            }
            _battle.alliances.refresh();
            Profiler.profile("create first alliance units", function():void {
               createAllianceUnits(_battle.alliances.getItemAt(0) as BAlliance, 1);
            });
            Profiler.profile("create trees between teams", function():void {
               placeFolliages(currentCell.x+1, currentCell.x + DISTANCE_BETWEEN_TEAMS_IN_CELLS - 1);
            });
            Profiler.profile("create second alliance units", function():void {
               createAllianceUnits(_battle.alliances.getItemAt(1) as BAlliance, 2);
            });
         } 
         else
         {
            createFfaFlanks();
         }
      }
      
      public function getRandomUnit(): BUnitComp
      {
         return units.getRandomValue(_battle.rand);
      }
      
      private function groupObject(participant: BBattleParticipantComp, hash: Hash): void
      {
         var minGroup: BBattleParticipantComp = null;
         for each (
            var groupRoot: IBattleParticipantModel in participant is BBuildingComp
            ? _battle.buildings
            : (participant.participantModel.kind == UnitKind.GROUND
               ? (participant as BUnitComp).flank.groundUnits
               : (participant as BUnitComp).flank.spaceUnits)
         )
         {
            if ((groupRoot.type == participant.participantModel.type) && 
               (groupRoot.id != participant.participantModel.id) &&
               ((hash[groupRoot.id] != null) &&
                  (hash[groupRoot.id] as BBattleParticipantComp).hidden == false))
            {
               if (participant is BUnitComp && (participant.participantModel as BUnit).appearOrder > 0)
               {
                  if ((groupRoot as BUnit).appearOrder <= (participant.participantModel as BUnit).appearOrder 
                     && (groupRoot as BUnit).deathOrder >= (participant.participantModel as BUnit).appearOrder)
                  {
                     if (minGroup == null)
                     {
                        minGroup = hash[groupRoot.id];
                     }
                     else
                     {
                        if (minGroup.totalGroupLength > (hash[groupRoot.id] as BBattleParticipantComp).totalGroupLength)
                           minGroup = hash[groupRoot.id];
                     } 
                  }
               }
               else
               {
                  if (minGroup == null)
                  {
                     minGroup = hash[groupRoot.id];
                  }
                  else
                  {
                     if (minGroup.totalGroupLength > (hash[groupRoot.id] as BBattleParticipantComp).totalGroupLength)
                        minGroup = hash[groupRoot.id];
                  }
               }
            }
         }
         if (minGroup == null)
            throw new Error("grouping failed: No place for unit " + participant.participantModel.type);
         minGroup.addParticipant(participant.participantModel);
         hash[participant.participantModel.id] = minGroup;
         
      }
      
      private function createFfaFlanks(): void
      {
         var flankArray : Array = [];
         for each (var ally: BAlliance in _battle.alliances)
         {
            for (var i: int = 0; i<ally.flanks.length; i++)
            {
               flankArray.push(ally.flanks.getItemAt(i));
            }
         }
         ArrayUtil.shuffle(flankArray, _battle.rand);
         var oldFlankEnd: int = 0;
         for (i = 0; i<flankArray.length; i++)
         {
            if ((flankArray[i] as BFlank).hasUnits)
            {
               oldFlankEnd = prepareFlank(flankArray[i] as BFlank, 
                  i<(flankArray.length/2)?1:2, oldFlankEnd);
            }
         }
      }
      
      
      private function createAllianceUnits(alliance:BAlliance, defaultDirection: int) : void
      {
         var oldFlankEnd: int = 0;
         alliance.flanks.sort = new Sort();
         alliance.flanks.sort.fields = [new SortField("flankNr", true, defaultDirection != 2, true)];
         alliance.flanks.refresh();
         for (var i: int = 0; i<alliance.flanks.length; i++)
         {
            if ((alliance.flanks.getItemAt(i) as BFlank).hasUnits)
            {
               Profiler.start("prepare flank " + i);
               oldFlankEnd = prepareFlank(alliance.flanks.getItemAt(i) as BFlank, 
                  defaultDirection, oldFlankEnd);
               Profiler.end();
            }
         }
      }
      
      private function prepareFlank(flank: BFlank, defaultDirection: int, oldFlankEnd: int): int
      {
         //mark flank start
         unitsMatrix.isFree(currentCell, new Point(currentCell.x, 1) );
         unitsMatrix.occupyCell(currentCell.x, 0, BattleMatrix.TAKEN);
         if (defaultDirection == 1)
         {
            flank.cellsToFree.start = oldFlankEnd;
            flank.cellsToFree.end = currentCell.x;
         }
         //increase x for flank to start
         currentCell.x += 1;
         //create the flank
         flank.flankStart = currentCell.x;
         
         Profiler.start("create flank");
         createFlank(flank, defaultDirection, currentCell.x);
         Profiler.end();
         
         currentCell.x += 1;
         unitsMatrix.isFree(new Point(currentCell.x - 1, 1), new Point(currentCell.x, 1));
         unitsMatrix.occupyCell(currentCell.x, 0, BattleMatrix.TAKEN);
         oldFlankEnd = currentCell.x;
         if (defaultDirection == 2)
         {
            flank.cellsToFree.start = currentCell.x;
            flank.cellsToFree.end = currentCell.x + FLANK_OFFSET_IN_CELLS;
         }
         //place trees between flanks
         placeFolliages(currentCell.x+1, currentCell.x + FLANK_OFFSET_IN_CELLS - 1);
         currentCell.x += 1;
         //increase x by the size of flank offset
         unitsMatrix.isFree(currentCell, new Point(currentCell.x, 1));
         return oldFlankEnd;
      }
      
      
      private function placeUnitKind(kind:String, flank:BFlank, flankUnits:ModelsCollection, 
                                     defaultDirection: int, flankStart: int): void {
         // Ensure first unit is always at the bottom from middle line.
         flank.placeFinder = new PlaceFinder(MAX_FLANK_WIDTH, (kind == UnitKind.GROUND
            ? groundUnitsHeight
            : spaceUnitsHeight), _battle.rand);
         var unit: BUnit;
         var isGround: Boolean = kind == UnitKind.GROUND;
         
         Profiler.start("sort " + kind + " units");
         flankUnits.sort = new Sort();
         flankUnits.sort.fields = [new SortField('appearOrder', true, false, true)];
         flankUnits.refresh();
         Profiler.end();
         
         var distinctTypes: ArrayCollection = new ArrayCollection();
         var distinctUnits: ArrayCollection = new ArrayCollection();
         var later: Array = [];
         
         Profiler.start("find distinct " + kind + " units");
         for each (unit in flankUnits)
         {
            if (unit.appearOrder > 0)
            {
               var isDistinct: Boolean = true;
               for each (var distinctUnit: BUnit in distinctUnits)
               {
                  if (distinctUnit.type == unit.type &&
                     (distinctUnit.appearOrder <= unit.appearOrder && distinctUnit.deathOrder >= unit.appearOrder))
                  {
                     isDistinct = false;
                     break;
                  }
               }
               if (isDistinct)
               {
                  distinctUnits.addItem(unit);
               }
               else
               {
                  later.push(unit);
               }
            }
            else
            {
               if (distinctTypes.getItemIndex(unit.type) == -1)
               {
                  distinctTypes.addItem(unit.type);
                  distinctUnits.addItem(unit);
               }
               else
               {
                  later.push(unit);
               }
            }
         }
         Profiler.end();
         
         Profiler.start("sort distinct " + kind + " units");
         distinctUnits.sort = new Sort();
         distinctUnits.sort.compareFunction = function (a:Object, b:Object, fields:Array = null):int
         {
            if (a.box.width > b.box.width)
               return -1;
            else
               if (a.box.width == b.box.width)
                  return 0;
            return 1;
         }
         distinctUnits.refresh();
         Profiler.end();
         
         Profiler.start("place distinct " + kind + " units");
         for each (unit in distinctUnits)
         {            
            createUnit(unit, isGround, flank, true);
         }
         Profiler.end();
         Profiler.start("place other " + kind + " units");
         for each (unit in later)
         {      
            createUnit(unit, isGround, flank);
         }
         Profiler.end();
         
         
         Profiler.start("refresh prepared objects");
         var xStart: int = flank.placeFinder.getXStartFree();
         var xEnd: int = flank.placeFinder.getXEndFree();
         var unitsWidth: int = flank.placeFinder.maxWidth - xEnd - xStart;
         flank.flankEnd = Math.max(flankStart + unitsWidth-1, flank.flankEnd);
         for each (var obj: * in preparedObjects)
         {
            obj.xGridPos += (flankStart - xStart);
            obj.yGridPos += isGround
               ? groundStart
               : SPACE_UNITS_TOP;
            var leftTop: Point = new Point(obj.xGridPos, obj.yGridPos);
            var rightBottom: Point = new Point(obj.getWidthInCells(GRID_CELL_WIDTH) + obj.xGridPos - 1, 
               obj.getHeightInCells(GRID_CELL_HEIGHT) + obj.yGridPos - 1);
            obj.depth = obj.yGridPos;
            if (unitsMatrix.isFree(leftTop, rightBottom))
            {
               unitsMatrix.occupy(leftTop,rightBottom);
            }
            else
            {
               throw new Error('you have tried to occupy the cell that has already been occupied, x:' + leftTop.x +
                  ' y:'+ leftTop.y+' xEnd:'+rightBottom.x+' yEnd:'+rightBottom.y);
            }
            if (obj is BFoliageComp)
            {
               obj.x = obj.xGridPos * GRID_CELL_WIDTH
                  + (_battle.rand.random() * (GRID_CELL_WIDTH * obj.getWidthInCells(GRID_CELL_WIDTH) 
                     - obj.width));
               obj.y = obj.yGridPos * GRID_CELL_HEIGHT
                  + (_battle.rand.random() * (GRID_CELL_HEIGHT * obj.getHeightInCells(GRID_CELL_HEIGHT) 
                     - obj.height));
            }
            else
            {
               if (defaultDirection == 2)
                  obj.flipHorizontally();
               obj.x = obj.xGridPos * GRID_CELL_WIDTH
                  + (_battle.rand.random() * (GRID_CELL_WIDTH * obj.getWidthInCells(GRID_CELL_WIDTH) 
                     - obj.boxWidth)) - obj.xOffset;
               obj.y = obj.yGridPos * GRID_CELL_HEIGHT
                  + (_battle.rand.random() * (GRID_CELL_HEIGHT * obj.getHeightInCells(GRID_CELL_HEIGHT) 
                     - obj.boxHeight)) - obj.yOffset;
            }
         }
         preparedObjects = [];
         Profiler.end();
      }
      
      /**
       * 
       * @param flank
       * @param section
       * @return flank width
       * 
       */
      private function createFlank(flank:BFlank, defaultDirection: int, flankStart: int) : void
      {
         placeUnitKind(UnitKind.SPACE, flank, flank.spaceUnits, defaultDirection, flankStart);
         placeUnitKind(UnitKind.GROUND, flank, flank.groundUnits, defaultDirection, flankStart);
         currentCell.x = flank.flankEnd;
      }
      
      public var unitsMatrix: BattleMatrix;
      
      private var currentCell: Point;
      
      private var preparedObjects: Array = [];
      
      public var folliages: ArrayCollection;
      
      private function createUnit(unit:BUnit, ground: Boolean, flank: BFlank, distinct: Boolean = false): void
      {
         Profiler.start("Create unit " + unit.toString());
         unit.actualHp = unit.hp;
         if (unit.appearOrder == 0)
         {
            var hpEntry: BOverallHp;
            switch (unit.playerStatus)
            {
               case Owner.PLAYER:
                  hpEntry = overallHp.selfHp;
                  break;
               case Owner.ALLY:
                  hpEntry = overallHp.allyHp;
                  break;
               case Owner.ENEMY:
                  hpEntry = overallHp.enemyHp;
                  break;
               case Owner.NAP:
                  hpEntry = overallHp.napHp;
                  break;
            }
            if (ground)
            {
               hpEntry.groundMax += unit.maxHp;
               hpEntry.groundCurrent += unit.actualHp;
            }
            else
            {
               hpEntry.spaceMax += unit.maxHp;
               hpEntry.spaceCurrent += unit.actualHp;
            }
         }
         Profiler.start('Creating component');
         var unitComp:BUnitComp = new BUnitComp(unit); 
         Profiler.end();
         unitComp.flank = flank;
         var unitWidthInCells:int = unitComp.getWidthInCells(GRID_CELL_WIDTH);
         var unitHeightInCells:int = unitComp.getHeightInCells(GRID_CELL_HEIGHT);
         var unitPlace: Point = flank.placeFinder.findPlace(unitWidthInCells, unitHeightInCells, distinct);
         
         if (unitPlace == null)
         {
            if (distinct)
            {
               throw new Error('no place for distinct unit ' + unit.type);
            }
            else
            {
               unitComp.hidden = true;
               units[unit.id] = unitComp;
               groupObject(unitComp, units);
               Profiler.end();
               return;
            }
         }
         else
         {
            unitComp.xGridPos = unitPlace.x;
            unitComp.yGridPos = unitPlace.y;
            units[unit.id] = unitComp;
         }
         preparedObjects.push(unitComp);
         Profiler.end();
         
         if (ground)
         {
            Profiler.start('placingFolliage');
            var folliagePlaced: Boolean = false;
            if (_battle.rand.boolean(FOLLIAGE_AFTER_UNIT_CHANCE))
            {
               placeFolliage(flank.placeFinder);
               folliagePlaced = true;
            }
            
            while (folliagePlaced)
            {
               folliagePlaced = false;
               if (_battle.rand.boolean(FOLLIAGE_AFTER_FOLLIAGE_CHANCE))
               {
                  placeFolliage(flank.placeFinder);
               }
            }
            Profiler.end();
         }
      }
      
      
      
      private function placeFolliage(placeFinder: PlaceFinder): void
      {
         
         var fFollComp: BFoliageComp = new BFoliageComp(TerrainType.getType(
            _battle.location.variation), _battle.rand);
         var follWidthInCells:int = fFollComp.getWidthInCells(GRID_CELL_WIDTH);
         var follHeightInCells:int = fFollComp.getHeightInCells(GRID_CELL_HEIGHT);
         var follPlace: Point = placeFinder.findPlace(follWidthInCells, follHeightInCells);
         
         if (follPlace != null)
         {
            fFollComp.xGridPos = follPlace.x;
            fFollComp.yGridPos = follPlace.y;
            folliages.addItem(fFollComp);
            preparedObjects.push(fFollComp);
         }
      }
      
      
      public function getUnitWithId(id:int) : BUnitComp
      {
         return units[id];
      }
      
      public function removeUnitWithId(id:int) : BUnitComp
      {
         var unitToRemove:BUnitComp = getUnitWithId(id);
         if (!unitToRemove)
         {
            return null;
         }
         unitToRemove.depth = 1;
         if (BattleConfig.getUnitDeathPassable(unitToRemove.getModel().type))
         {
            unitsMatrix.free(new Point(unitToRemove.xGridPos, unitToRemove.yGridPos),
               new Point(unitToRemove.xGridPos + unitToRemove.getWidthInCells(GRID_CELL_WIDTH),
                  unitToRemove.yGridPos + unitToRemove.getHeightInCells(GRID_CELL_HEIGHT)));
         }
         // TODO: make this normal
         units.removeValue(unitToRemove);
         return unitToRemove;
      }
      
      
      public function removeUnit(unit:BUnitComp) : BUnitComp
      {
         if (!unit)
         {
            return null;
         }
         return removeUnitWithId(unit.participantModel.id);
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      public override function set model(v:BaseModel) : void
      {
         //         throw new IllegalOperationError("model property is not supported");
      }
      
      
      public override function get model() : BaseModel
      {
         //         throw new IllegalOperationError("model property is not supported");
         return null;
      }
   }
}