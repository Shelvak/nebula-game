package models.location
{
   import models.BaseModel;
   
   import org.flexunit.internals.namespaces.classInternal;
   
   public class LocationMinimal extends BaseModel implements ILocation
   {
      /**
       * Constructor.
       */
      public function LocationMinimal()
      {
         super();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      
      private var _type:uint = LocationType.GALAXY;
      [Optional]
      [Bindable(event="willNotChange")]
      public function set type(value:uint) : void
      {
         _type = value;
      }
      public function get type() : uint
      {
         return _type;
      }
      
      
      [Optional]
      /**
       * Either X coordinate if <code>type</code> is <code>LocationType.GALAXY</code> or angle if
       * type is <code>LocationType.SOLAR_SYSTEM</code> or <code>LocationType.PLANET</code>.
       */
      public var x:int = 0;
      
      
      [Optional]
      /**
       * Either Y coordinate if <code>type</code> is <code>LocationType.GALAXY</code> or position if
       * type is <code>LocationType.SOLAR_SYSTEM</code> or <code>LocationType.PLANET</code>.
       */
      public var y:int = 0;
      
      
      [Bindable(event="willNotChange")]
      public function get isSSObject() : Boolean
      {
         return type == LocationType.SS_OBJECT;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get isSolarSystem() : Boolean
      {
         return type == LocationType.SOLAR_SYSTEM;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get isGalaxy() : Boolean
      {
         return type == LocationType.GALAXY;
      }
      
      
      /**
       * Indicates if this location is defined by one of cached maps and therefore is currently
       * viewed by the player.
       */
      public function get isObserved() : Boolean
      {
         return ML.latestSSObject && !ML.latestSSObject.fake && ML.latestSSObject.planet && ML.latestSSObject.planet.definesLocation(this) ||
                ML.latestGalaxy && !ML.latestGalaxy.fake && ML.latestGalaxy.definesLocation(this) ||
                ML.latestSolarSystem && !ML.latestSolarSystem.fake && ML.latestSolarSystem.definesLocation(this);
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      
      /**
       * Checks if two locations are equal. <code>model</code> is equal to this location if
       * all of following conditions are met:
       * <ul>
       *    <li><code>o</code> is not <code></code></li>
       *    <li><code>o</code> is instance of <code>LocationMinimal</code></li>
       *    <li><code>id</code>, <code>type</code>, <code>x</code> and <code>y</code> all hold the
       *        same values</li>
       * </ul>
       * 
       * @param o instance of <code>LocationMinimal</code> to compare this location with
       * 
       * @return <code>true</code> if given location is equal to this one or <code>false</code>
       * otherwise 
       */
      public override function equals(o:Object) : Boolean
      {
         if (o is LocationMinimal)
         {
            var loc:LocationMinimal = LocationMinimal(o);
            return loc == this || loc.type == type && loc.id == id && loc.x == x && loc.y == y;
         }
         return false;
      }
      
      
      /**
       * <code>LocationMinimal.hashKey()</code> returns string of the following format:
       * <p>
       * <code>models.location::LocationMinimal,{type},{id},{x},{y}</code><br/>
       * where:
       * <ul>
       *    <li><code>{type}</code> - type of this location (one of constants in
       *        <code>LocationType</code> class)</li>
       *    <li><code>{id}</code> id of location (galaxy, solar system or planet id)</li>
       *    <li><code>{x}</code> - value of <code>x</code> property</li>
       *    <li><code>{y}</code>  - value of <code>x</code> property</li>
       * </ul>
       * <p>
       */
      public override function hashKey() : String
      {
         return "models.location::LocationMinimal," + type + "," + id + "," + x + "," + y;
      }
      
      
      public override function toString():String
      {
         return "[class: " + className + ", type: " + type + ", id: " + id + ", x: " + x + ", y: " + y + "]";
      }
   }
}