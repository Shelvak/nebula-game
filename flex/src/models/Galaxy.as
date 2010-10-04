package models
{
   import models.events.GalaxyEvent;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.Map;
   import models.map.MapType;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   
   import namespaces.client_internal;
   
   import utils.ClassUtil;
   
   
   /**
    * Dispatched when galaxy dimensions have changed (<code>client_internal::setMinMaxProperties()<code>)
    * has been called.
    * 
    * @eventType models.events.GalaxyEvent.RESIZE
    */
   [Event(name="resize", type="models.events.GalaxyEvent")]
   
   /**
    * Dispatched when new solar system has been added to this galaxy. Is not dispatched when
    * <code>solarSystems</code> property is set.
    * 
    * @eventType models.events.GalaxyEvent.SOLAR_SYSTEM_ADD
    */
   [Event(name="solarSystemAdd", type="models.events.GalaxyEvent")]
   
   /**
    * Dispatched when a solar system has been removed from this galaxy. Is not dispatched when
    * <code>solarSystems</code> property is set.
    * 
    * @eventType models.events.GalaxyEvent.SOLAR_SYSTEM_REMOVE
    */
   [Event(name="solarSystemRemove", type="models.events.GalaxyEvent")]
   
   /**
    * A galaxy. 
    */
   [Bindable]
   public class Galaxy extends Map
   {
      [Bindable(event="resize")]
      /**
       * Minimum x value of a solar system tile in this galaxy.
       */
      public var minX: int = 0;
      
      
      [Bindable(event="resize")]
      /**
       * Maximum x value of a solar system tile in this galaxy. 
       */
      public var maxX: int = 0;
      
      
      [Bindable(event="resize")]
      /**
       * Minimum y value of a solar system tile in this galaxy.
       */      
      public var minY: int = 0;
      
      
      [Bindable(event="resize")]
      /**
       * Minimum y value of a solar system tile in this galaxy. 
       */
      public var maxY: int = 0;
      
      
      /**
       * Sets <code>minX</code>, <code>minY</code>, <code>maxX</code> and <code>maxY</code>
       * properties. Values are determined from the list of solar systems.
       * <p>This operation is expensive in terms of performance so it is not
       * called every time a solar system is added to a galaxy. Instead you
       * should call this method when you have altered a list of solar systems
       * for the last time. When <code>solarSystems</code> property is changed
       * (nor <code>addSolarSystem</code> neither <code>removeSolarSystem</code>
       * methods are used) this method is called automaticly.</p>
       */      
      client_internal function setMinMaxProperties () :void
      {
         var minX: Number = Number.POSITIVE_INFINITY;
         var maxX: Number = Number.NEGATIVE_INFINITY;
         var minY: Number = minX;
         var maxY: Number = maxX;
         
         for each (var ss: SolarSystem in solarSystems)
         {
            minX = Math.min (minX, ss.x);
            maxX = Math.max (maxX, ss.x);
            minY = Math.min (minY, ss.y);
            maxY = Math.max (maxY, ss.y);
         }
         
         this.minX = minX;
         this.maxX = maxX;
         this.minY = minY;
         this.maxY = maxY;
         
         dispatchEvent(new GalaxyEvent(GalaxyEvent.RESIZE));
      }
      
      
      [Bindable(event="resize")]
      /**
       * Width of galaxy in tiles.
       * 
       * @default 0
       */
      public function get width () :int
      {
         return maxX - minX + 1;
      }
      
      
      [Bindable(event="resize")]
      /**
       * Height of a galaxy in tiles.
       * 
       * @default 0 
       */
      public function get height () :int
      {
         return maxY - minY + 1;
      }
      
      
      [Bindable(event="resize")]
      /**
       * -minX. Need this because server assumes that galaxy center is in the
       * center of a plane while client thinks it is the top left corner of
       * a plane. 
       */
      public function get xOffset () :int
      {
         return -minX;
      }
      
      
      [Bindable(event="resize")]
      /**
       * -minY. Need this because server assumes that galaxy center is in the
       * center of a plane while client thinks it is the top left corner of
       * a plane.
       */
      public function get yOffset () :int
      {
         return -minY;
      }
      
      
      /**
       * Date when this galaxy was created.
       * 
       * @default null
       */
      public var createdOn: Date = null;
      
      
      private var _solarSystems:ModelsCollection = new ModelsCollection ();
      /**
       * Collection of solar systems this galaxy consists of.
       * <p>
       * Items of the collection are of <code>SolarSystem</code> type.
       * </p>
       * 
       * @default empty collection
       */
      public function set solarSystems (value:ModelsCollection) :void
      {
         if (value != _solarSystems)
         {
            _solarSystems = value;
            client_internal::setMinMaxProperties ();
            dispatchObjectsListChangeEvent();
         }
      }
      /**
       * @private
       */
      public function get solarSystems() : ModelsCollection
      {
         return _solarSystems;
      }
      
      
      /**
       * Looks and returns for a solar system with a given id
       * @param id
       * @return instance of <code>SolarSystem</code> or <code>null</code>
       * if a solar system with given id does not exists. 
       * 
       */
      public function getSSById(id:int) : SolarSystem
      {
         return solarSystems.findModel(id);
      }
      
      
      public function addSolarSystem(solarSystem:SolarSystem) : void
      {
         ClassUtil.checkIfParamNotNull("solarSystem", solarSystem);
         _solarSystems.addItem(solarSystem);
         dispatchEvent(new GalaxyEvent(GalaxyEvent.SOLAR_SYSTEM_ADD, solarSystem));
      }
      
      
      /**
       * Removes a given solar system (if one exists) form this galaxy. 
       */
      public function removeSolarSystem(solarSystem:SolarSystem) : void
      {
         if (solarSystems.contains(solarSystem))
         {
            solarSystems.removeItem(solarSystem);
            dispatchEvent(new GalaxyEvent(GalaxyEvent.SOLAR_SYSTEM_REMOVE, solarSystem));
         }
      };
      
      
      [Bindable("mapObjectsListChange")]
      /**
       * Returns same collection as <code>solarSystems</code>.
       * 
       * @see models.map.Map#objects
       * @see models.Galaxy#solarSystems
       */
      public override function get objects() : ArrayCollection
      {
         return solarSystems;
      };
      
      
      [Bindable("willNotChange")]
      /**
       * Returns <code>MapType.GALAXY</code>.
       * 
       * @see models.map.Map#mapType
       */
      override public function get mapType() : int
      {
         return MapType.GALAXY;
      };
      
      
      /**
       * Galaxy locations are not bounded to visible map square.
       */
      public override function definesLocation(location:LocationMinimal) : Boolean
      {
         return location.type == LocationType.GALAXY && location.id == id;
      }
      
      
      protected override function get definedLocationType() : int
      {
         return LocationType.GALAXY;
      }
      
      
      protected override function setCustomLocationFields(location:Location) : void
      {
      }
   }
}