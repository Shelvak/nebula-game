package components.map.space
{
   import controllers.Messenger;

   import models.BaseModel;
   import models.ModelLocator;
   import models.galaxy.Galaxy;
   import models.galaxy.IVisibleGalaxyAreaClient;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.IMStaticMapObject;
   import models.map.IMStaticSpaceObject;
   import models.map.MMapSpace;
   import models.map.MStaticSpaceObjectsAggregator;

   import mx.collections.ArrayCollection;

   import spark.components.Group;

   import utils.locale.Localizer;


   public class CMapGalaxy extends CMapSpace implements IVisibleGalaxyAreaClient
   {
      /**
       * Called by <code>NavigationController</code> when galaxy map screen is shown.
       */
      public static function screenShowHandler() : void {
         if (!ModelLocator.getInstance().latestGalaxy.canBeExplored) {
            Messenger.show(
               Localizer.string("Galaxy", "message.noRadar"),
               Messenger.VERY_LONG, 'info/galaxy'
            );
         }
      }
      
      /**
       * Called by <code>NavigationController</code> when galaxy map screen is hidden.
       */
      public static function screenHideHandler() : void {
         Messenger.hide();
      }

      public static const COMP_CLASSES:StaticObjectComponentClasses =
         new StaticObjectComponentClasses();
      COMP_CLASSES.addComponents(MMapSpace.STATIC_OBJECT_NATURAL, CSolarSystem, CSolarSystemInfo);
      COMP_CLASSES.addComponents(MMapSpace.STATIC_OBJECT_COOLDOWN, CCooldown, CCooldownInfo);
      COMP_CLASSES.addComponents(MMapSpace.STATIC_OBJECT_WRECKAGE, CWreckage, CWreckageInfo);
      
      
      /* ###################### */
      /* ### INITIALIZATION ### */
      /* ###################### */
      
      public function CMapGalaxy(model:Galaxy) {
         super(model);
      }
      
      public override function cleanup() : void {
         super.cleanup();
         
         for each (var sectorObject:SectorsHashItem in _staticObjectsHash.getAllItems()) {
            if (sectorObject.object != null) {
               _staticObjectsPool.returnObject(sectorObject.object);
               sectorObject.object = null;
            }
         }
      }
      
      public function getGalaxy() : Galaxy {
         return Galaxy(model);
      }
      
      override protected function createGrid() : Grid {
         return new GridGalaxy(this);
      }
      
      protected override function createCustomComponentClasses() : StaticObjectComponentClasses {
         return COMP_CLASSES;
      }
      
      
      private var _fowRenderer:FOWRenderer;
      override protected function createBackgroundObjects(objectsContainer:Group) : void {
         super.createBackgroundObjects(objectsContainer);
         var _fowContainer: Group = new Group();
         _fowContainer.left = 0;
         _fowContainer.right = 0;
         _fowContainer.top = 0;
         _fowContainer.bottom = 0;
         objectsContainer.addElement(_fowContainer);
         _fowRenderer = new FOWRenderer(
            Galaxy(model),
            GridGalaxy(grid),
            _fowContainer.graphics
         );
      }
      
      
      /* ################################# */
      /* ### IVisibleGalaxyAreaTracker ### */
      /* ################################# */
      
      private var _staticObjectsPool:SectorStaticObjectsPool;
      private const _staticObjectsHash:SectorsHash = new SectorsHash();
      
      public function sectorHidden(x:int, y:int) : void {
         var sector:SectorsHashItem = _staticObjectsHash.remove(getTmpSector(x, y));
         if (sector.hasObject) {
            if (selectedStaticObject == sector.object) {
               f_retainSelectedLocation = true;
               deselectSelectedObject();
            }
            _staticObjectsPool.returnObject(sector.object);
         }
      }
      
      public function sectorShown(x:int, y:int) : void {
         var modelsInSector:ArrayCollection =
                new ArrayCollection(getGalaxy().getStaticObjectsAt(x, y));
         var sector:SectorsHashItem = new SectorsHashItem(x, y);
         _staticObjectsHash.add(sector);
         var aggrComponent:CStaticSpaceObjectsAggregator;
         var aggrModel:MStaticSpaceObjectsAggregator;
         if (modelsInSector.length > 0) {
            sector.object = _staticObjectsPool.borrowObject();
            aggrComponent = sector.object;
            aggrModel = aggrComponent.model;
            try {
               aggrModel.addAll(modelsInSector);
            }
            catch (err:Error) {
               throw new Error(
                  "Error while trying to add static objects "
                     + modelsInSector.toArray().join(", ")
                     + " at (" + x + "; " + y + ")"
                     + " to borrowed CStaticSpaceObjectsAggregator "
                     + aggrComponent + ". Original error message:"
                     + "\n" + err.message
               );
            }
            grid.positionStaticObjectInSector(aggrModel.currentLocation);
            squadronsController.repositionAllSquadronsIn(aggrModel.currentLocation);
            var model:IMStaticSpaceObject = IMStaticSpaceObject(aggrModel.getItemAt(0)); 
            if (_selectedLocation != null
                && _selectedLocation.equals(model.currentLocation)) {
               selectModel(BaseModel(model));
            }
         }
      }
      
      internal function getLocationsInVisibleArea() : Array {
         var sectors:Array = new Array();
         for each (var item:SectorsHashItem in _staticObjectsHash.getAllItems()) {
            var loc:LocationMinimal = new LocationMinimal();
            loc.id = getGalaxy().id;
            loc.type = LocationType.GALAXY;
            loc.x = item.x;
            loc.y = item.y;
            sectors.push(loc);
         }
         return sectors;
      }
      
      internal function getStaticObjectInSector(x:int, y:int) : CStaticSpaceObjectsAggregator {
         var sector:SectorsHashItem = getTmpSector(x, y);
         if (_staticObjectsHash.has(sector)) {
            return _staticObjectsHash.getItem(sector).object;
         }
         else {
            return null;
         }
      }
      
      
      /* ############### */
      /* ### OBJECTS ### */
      /* ############### */
      
      protected override function createStaticObjects(objectsContainer:Group) : void {
         _staticObjectsPool = new SectorStaticObjectsPool(objectsContainer);
      }
      
      protected override function createOrUpdateStaticObject(object:IMStaticSpaceObject) : void {
         var sector:SectorsHashItem = getTmpSector(
            object.currentLocation.x,
            object.currentLocation.y
         );
         var aggrComponent:CStaticSpaceObjectsAggregator;
         var aggrModel:MStaticSpaceObjectsAggregator;
         if (_staticObjectsHash.has(sector)) {
            sector = _staticObjectsHash.getItem(sector);
            if (!sector.hasObject) {               
               sector.object = _staticObjectsPool.borrowObject();
            }
            aggrComponent = sector.object;
            aggrModel = aggrComponent.model;
            aggrModel.addItem(object);
            grid.positionStaticObjectInSector(object.currentLocation);
            squadronsController.repositionAllSquadronsIn(object.currentLocation);
         }
      }
      
      protected override function destroyOrUpdateStaticObject(object:IMStaticSpaceObject) : void {
         var sector:SectorsHashItem = getTmpSector(
            object.currentLocation.x,
            object.currentLocation.y
         );
         if (_staticObjectsHash.has(sector)) {
            sector = _staticObjectsHash.getItem(sector);
            if (sector.hasObject) {
               var aggrComponent:CStaticSpaceObjectsAggregator = sector.object;
               var aggrModel:MStaticSpaceObjectsAggregator = aggrComponent.model;
               aggrModel.removeItemAt(aggrModel.getItemIndex(object));
               if (aggrModel.length == 0) {
                  if (object.currentLocation.equals(_selectedLocation)) {
                     deselectSelectedObject();
                  }
                  _staticObjectsPool.returnObject(aggrComponent);
                  squadronsController.repositionAllSquadronsIn(object.currentLocation);
               }
            }
         }
      }
      
      private const _tmpSectorsHashItem:SectorsHashItem = new SectorsHashItem(0, 0);
      private function getTmpSector(x:int, y:int) : SectorsHashItem {
         _tmpSectorsHashItem.x = x;
         _tmpSectorsHashItem.y = y;
         return _tmpSectorsHashItem;
      }
      
      
      /* ############### */
      /* ### VISUALS ### */
      /* ############### */
      
      private var f_galaxySizeChanged:Boolean = true;
      
      protected override function updateDisplayList(uw:Number, uh:Number) : void {
         super.updateDisplayList(uw, uh);
         
         if (f_galaxySizeChanged) {
            _fowRenderer.redraw();
            f_galaxySizeChanged = false;
         }
      }
      
      
      /* ############################## */
      /* ### SOLAR SYSTEM SELECTION ### */
      /* ############################## */
      
      private var f_retainSelectedLocation:Boolean = false;
      private var _selectedLocation:LocationMinimal = null;
      
      protected override function selectModel(model:BaseModel) : void {
         if (model is IMStaticSpaceObject || model is LocationMinimal) {
            var loc: LocationMinimal =
                   model is IMStaticMapObject
                      ? IMStaticSpaceObject(model).currentLocation
                      : LocationMinimal(model);
            if (!getGalaxy().definesLocation(loc)) {
               return;
            }
            if (_selectedLocation == null || !_selectedLocation.equals(loc)) {
               deselectSelectedObject();
               _selectedLocation = loc;
               viewport.moveContentTo(
                  grid.getSectorRealCoordinates(_selectedLocation),
                  true
               );
            }
            var sectorObjects: SectorsHashItem =
               _staticObjectsHash.getItem(getTmpSector(
                  _selectedLocation.x,
                  _selectedLocation.y
               ));
            if (sectorObjects != null && sectorObjects.hasObject) {
               selectComponent(sectorObjects.object, false, true);
            }
         }
      }
      
      public override function selectComponent(component:Object,
                                               center:Boolean = false,
                                               openOnSecondCall:Boolean = false) : void {
         super.selectComponent(component, center, openOnSecondCall);
         if (selectedStaticObject != null) {
            _selectedLocation = selectedStaticObject.currentLocation;
         }
      }
      
      public override function deselectSelectedObject() : void {
         if (_selectedLocation != null) {
            if (!f_retainSelectedLocation) {
               _selectedLocation = null;
            }
            super.deselectSelectedObject();
         }
         f_retainSelectedLocation = false;
      }
   }
}


import components.map.space.CMapGalaxy;
import components.map.space.CStaticSpaceObjectsAggregator;

import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import models.map.MStaticSpaceObjectsAggregator;

import spark.components.Group;

import utils.Objects;
import utils.pool.BasePoolableObjectFactory;
import utils.pool.impl.StackObjectPool;


class SectorsHashItem
{
   public function SectorsHashItem(x:int, y:int) {
      this.x = x;
      this.y = y;
   }
   
   public var object:CStaticSpaceObjectsAggregator;
   public var x:int;
   public var y:int;
   
   public function get hasObject() : Boolean {
      return object != null;
   }
   
   public function get hashCode() : int {
      return x * 100000 + y;
   }
   
   public function toString() : String {
      return "[class: " + Objects.getClassName(this)
         + ", x: " + x
         + ", y: " + y
         + ", hashCode: " + hashCode
         + ", object: " + object + "]";
   }
}


class SectorsHash
{
   private const _hash:Dictionary = new Dictionary();
   
   public function SectorsHash() {
   }
   
   public function add(item:SectorsHashItem) : void {
      Objects.paramNotNull("item", item);
      if (!has(item)) {
         _hash[item.hashCode] = item;
      }
      else {
         throw new IllegalOperationError(
            "Collision detected: unable to add item " + item + " because another item "
            + getItem(item) + " has the same hash code"
         );
      }
   }
   
   public function remove(item:SectorsHashItem) : SectorsHashItem {
      Objects.paramNotNull("item", item);
      if (!has(item)) {
         throw new IllegalOperationError(
            "Unable to remove item " + item + " because it is not in the hash"
         );
      }
      var itemRemoved:SectorsHashItem = _hash[item.hashCode];
      delete _hash[item.hashCode];
      return itemRemoved;
   }
   
   public function has(item:SectorsHashItem) : Boolean {
      Objects.paramNotNull("item", item);
      return _hash[item.hashCode] != null;
   }
   
   public function getItem(item:SectorsHashItem) : SectorsHashItem {
      return _hash[item.hashCode];
   }
   
   public function getAllItems() : Vector.<SectorsHashItem> {
      var sectors:Vector.<SectorsHashItem> = new Vector.<SectorsHashItem>();
      for each (var item:SectorsHashItem in _hash) {
         sectors.push(item);
      }
      return sectors;
   }
}


class SectorStaticObjectsFactory extends BasePoolableObjectFactory
{
   private var _container:Group;
   
   public function SectorStaticObjectsFactory(objectsContainer:Group)  {
      super();
      _container = objectsContainer;
   }
   
   override public function makeObject() : Object {
      var comp:CStaticSpaceObjectsAggregator = new CStaticSpaceObjectsAggregator(
         new MStaticSpaceObjectsAggregator(),
         CMapGalaxy.COMP_CLASSES
      );
      _container.addElement(comp);
      return comp;
   }
   
   override public function activateObject(obj:Object) : void {
      var comp:CStaticSpaceObjectsAggregator = CStaticSpaceObjectsAggregator(obj);
      comp.visible = true;
   }
   
   override public function passivateObject(obj:Object) : void {
      var comp:CStaticSpaceObjectsAggregator = CStaticSpaceObjectsAggregator(obj);
      comp.model.removeAll();
      comp.selected = false;
      comp.visible = false;
   }
}


class SectorStaticObjectsPool
{
   private var _pool:StackObjectPool;
   
   public function SectorStaticObjectsPool(objectsContainer:Group) {
      super();
      _pool = new StackObjectPool(new SectorStaticObjectsFactory(objectsContainer))
   }
   
   /**
    * @see utils.pool.IObjectPool#borrowObject()
    */
   public function borrowObject() : CStaticSpaceObjectsAggregator {
      return CStaticSpaceObjectsAggregator(_pool.borrowObject());
   }

   /**
    * @see utils.pool.IObjectPool#returnObject()
    */
   public function returnObject(obj:CStaticSpaceObjectsAggregator) : void {
      _pool.returnObject(obj);
   }
}