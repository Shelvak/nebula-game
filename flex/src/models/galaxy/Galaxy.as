package models.galaxy
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   import models.IStaticSpaceSectorObject;
   import models.StaticSpaceObjectsAggregator;
   import models.events.GalaxyEvent;
   import models.location.Location;
   import models.location.LocationMinimal;
   import models.location.LocationType;
   import models.map.MMapSpace;
   import models.map.MapType;
   import models.solarsystem.SolarSystem;
   
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   
   
   /**
    * Dispatched when galaxy dimensions have changed.
    * 
    * @eventType models.events.GalaxyEvent.RESIZE
    */
   [Event(name="resize", type="models.events.GalaxyEvent")]
   
   
   /**
    * A galaxy. 
    */
   [Bindable]
   public class Galaxy extends MMapSpace
   {
      private var _fowMatrixBuilder:FOWMatrixBuilder;
      
      
      [Bindable(event="resize")]
      public function get bounds() : Rectangle
      {
         return _fowMatrixBuilder.getBounds();
      }
      
      
      [Bindable(event="resize")]
      public function get offset() : Point
      {
         return _fowMatrixBuilder.getCoordsOffset();
      }
      
      
      public function get fowMatrix() : Vector.<Vector.<Boolean>>
      {
         return _fowMatrixBuilder.getMatrix();
      }
      
      
      public function setFOWEntries(fowEntries:Vector.<Rectangle>, units:IList) : void
      {
         _fowMatrixBuilder = new FOWMatrixBuilder(fowEntries, getSolarSystems(), units);
         dispatchResizeEvent();
      }
      
      
      /**
       * Looks and returns for a solar system with a given id.
       * 
       * @param id
       * @return instance of <code>SolarSystem</code> or <code>null</code>
       * if a solar system with given id does not exists.
       */
      public function getSSById(id:int) : SolarSystem
      {
         for each (var aggregator:StaticSpaceObjectsAggregator in objects)
         {
            var ss:SolarSystem =
               SolarSystem(aggregator.findObjectOfType(StaticSpaceObjectsAggregator.TYPE_NATURAL));
            if (ss && ss.id == id)
            {
               return ss;
            }
         }
         return null;
      }
      
      
      [Bindable(event="willNotChange")]
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
      protected override function definesLocationImpl(location:LocationMinimal) : Boolean
      {
         return location.type == LocationType.GALAXY && location.id == id;
      }
      
      
      /**
       * Basicly does the same as <code>definesLocation()</code> but takes fog of war into account.
       */
      public function locationIsVisible(location:LocationMinimal) : Boolean
      {
         if (definesLocation(location))
         {
            var fowMatrix:Vector.<Vector.<Boolean>> = _fowMatrixBuilder.getMatrix(); 
            var x:int = location.x + offset.x;
            var y:int = location.y + offset.y;
            if (x >= 0 && x < bounds.width && y >= 0 && y < bounds.height)
            {
               return fowMatrix[x][y];
            }
         }
         return false;
      }
      
      
      protected override function get definedLocationType() : int
      {
         return LocationType.GALAXY;
      }
      
      
      protected override function setCustomLocationFields(location:Location) : void
      {
      }
      
      
      /* ############### */
      /* ### HELPERS ### */
      /* ############### */
      
      
      private function getSolarSystems() : ArrayCollection
      {
         var list:ArrayCollection = new ArrayCollection();
         for each (var aggregator:StaticSpaceObjectsAggregator in objects)
         {
            var ss:IStaticSpaceSectorObject = aggregator.findObjectOfType(StaticSpaceObjectsAggregator.TYPE_NATURAL);
            if (ss)
            {
               list.addItem(ss);
            }
         }
         return list;
      }
      
      
      private function dispatchResizeEvent() : void
      {
         if (hasEventListener(GalaxyEvent.RESIZE))
         {
            dispatchEvent(new GalaxyEvent(GalaxyEvent.RESIZE));
         }
      }
   }
}