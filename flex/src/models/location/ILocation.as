package models.location
{
   import interfaces.IEqualsComparable;

   public interface ILocation
   {
      /**
       * Type of this location. Value of one of <code>LocationType</code> constants:
       * <code>GALAXY</code>, <code>SOLAR_SYSTEM</code> or <code>PLANET</code>
       */
      function set type(value:uint) : void;
      /**
       * @private
       */
      function get type() : uint;
      
      
      /**
       * Id of a location.
       */
      function set id(value:int) : void;
      /**
       * @private
       */
      function get id() : int;
      
      
      /**
       * X coordinate of the location.
       */
      function set x(value:int) : void;
      /**
       * @private
       */
      function get x() : int;
      
      
      /**
       * Y coordinate of the location.
       */
      function set y(value:int) : void;
      /**
       * @private
       */
      function get y() : int;
   }
}