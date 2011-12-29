package models.location
{
   import flash.errors.IllegalOperationError;
   
   import models.BaseModel;
   import models.map.MMap;
   import models.solarsystem.SSKind;
   
   import utils.locale.Localizer;
   
   public class LocationMinimal extends BaseModel implements ILocation
   {
      /**
       * Returns label of a sector of the form: <code>Sector {loc.sectorName}</code>.
       * This method handles <code>nulls</code> silently: returns empty strings.
       */
      public static function getSectorLabel(loc:LocationMinimal) : String {
         return loc == null ? "" : Localizer.string('Location', 'sector') + " " + loc.sectorName;
      }
      
      
      public function LocationMinimal() {
         super();
      }
      
      
      /* ################## */
      /* ### PROPERTIES ### */
      /* ################## */
      
      [Optional]
      public var kind:uint;
      
      private var _type:uint = LocationType.GALAXY;
      [Optional]
      [Bindable]
      public function set type(value:uint) : void {
         if (_type != value)
            _type = value;
      }
      public function get type() : uint {
         return _type;
      }
      
      
      private var _x:int = 0;
      [Optional]
      public function set x(value:int) : void {
         _x = value;
      }
      public function get x() : int {
         return _x;
      }
      
      
      private var _y:int = 0;
      [Optional]
      public function set y(value:int) : void {
         _y = value;
      }
      public function get y() : int {
         return _y;
      }
      
      
      [Bindable(event="willNotChange")]
      public function get isSSObject() : Boolean {
         return type == LocationType.SS_OBJECT;
      }
      
      [Bindable(event="willNotChange")]
      public function get isSolarSystem() : Boolean {
         return type == LocationType.SOLAR_SYSTEM;
      }
      
      [Bindable(event="willNotChange")]
      public function get isBattleground() : Boolean {
         return isSolarSystem && ML.latestGalaxy.isBattleground(id);
      }
      
      [Bindable(event="willNotChange")]
      public function get isMiniBattleground() : Boolean {
         return isSolarSystem && kind == SSKind.BATTLEGROUND && !isBattleground;
      }
      
      [Bindable(event="willNotChange")]
      public function get isGalaxy() : Boolean {
         return type == LocationType.GALAXY;
      }
      
      [Bindable(event="willNotChange")]
      /**
       * Name of a sector defined by this instance of <code>LocationMinimal</code>. Returned string
       * is of the form: <code>x:y</code>. Make sense for <code>LocationType.GALAXY</code> and
       * <code>LocationType.SOLAR_SYSTEM<code> types only.
       */
      public function get sectorName() : String {
         return x + ":" + y;
      }
      
      /**
       * Indicates if this location is defined (from player perspective) by one of cached maps and therefore
       * is currently viewed by the player.
       */
      public function get isObserved() : Boolean {
         return ML.latestPlanet && !ML.latestPlanet.fake && ML.latestPlanet.definesLocation(this) ||
                ML.latestGalaxy && !ML.latestGalaxy.fake && ML.latestGalaxy.locationIsVisible(this) ||
                ML.latestSSMap && !ML.latestSSMap.fake && ML.latestSSMap.definesLocation(this);
      }
      
      
      /* ######################### */
      /* ### INTERFACE METHODS ### */
      /* ######################### */
      
      /**
       * Sets <code>x</code> and <code>y</code> to default values, which is <code>0</code>.
       */
      public function setDefaultCoordinates() : void {
         x = 0;
         y = 0;
      }
      
      /**
       * Tries to construct instance of <code>Location</code> from this <code>LocationMinimal</code>.
       * The call will be successful only if <code>this.isObserved == true</code>. If not, this
       * method will throw an error.
       * 
       * @throws IllegalOperationError if <code>this.isObserved == false</code>
       */
      public function toLocation() : Location {
         if (!isGalaxy && !isObserved) {
            throw new IllegalOperationError(
               "Can't construct instance of [class Location] from "
                  + this + ": [prop isObserved] must return true for this "
                  + "method to work but returned " + isObserved
            );
         }
         var map:MMap;
         switch (type) {
            case LocationType.GALAXY:
               map = ML.latestGalaxy;
               break;
            case LocationType.SOLAR_SYSTEM:
               map = ML.latestSSMap;
               break;
            case LocationType.SS_OBJECT:
               map = ML.latestPlanet;
               break;
            default:
               throw new ArgumentError("Location type " + type + " not supported");
               break;
         }
         return map.getLocation(x, y);
      }
      
      /**
       * Checks if two locations are equal. <code>model</code> is equal to this location if
       * all of following conditions are met:
       * <ul>
       *    <li><code>o</code> is not <code>null</code></li>
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
      public override function equals(o:Object) : Boolean {
         if (o is LocationMinimal) {
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
      public override function hashKey() : String {
         return "models.location::LocationMinimal," + type + "," + id + "," + x + "," + y;
      }
      
      public override function toString() : String {
         return "[class: " + className + ", type: " + type + ", id: " + id + ", x: " + x + ", y: " + y + "]";
      }
   }
}