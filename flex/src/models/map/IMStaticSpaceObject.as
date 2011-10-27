package models.map
{
   public interface IMStaticSpaceObject extends IMStaticMapObject
   {
      /**
       * Type of the static space object. One of the constants in <code>MMapSpace</code> class.
       */
      function get objectType() : int;     
      
      /**
       * Width of the object visual representation in pixels.
       */
      function get componentWidth() : int;
      
      /**
       * Height of the object visual representation in pixels.
       */
      function get componentHeight() : int;
      
      function toString() : String;
   }
}