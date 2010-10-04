package models.location
{
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
   }
}