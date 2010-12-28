package models
{
   import flash.display.BitmapData;
   
   import models.location.LocationMinimal;

   
   public interface IStaticSpaceSectorObject extends IBaseModel
   {
      /**
       * Type of the static space object. One of the constants in <code>StaticSpaceSectorObjects</code> class.
       */
      function get objectType() : String;
      
      
      /**
       * Location of this static space object.
       */
      function get currentLocation() : LocationMinimal;
      
      
      /**
       * Image of this space object.
       */
      function get imageData() : BitmapData;
      
      
      /**
       * Width of the object visual representation in pixels.
       */
      function get componentWidth() : int;
      
      
      /**
       * Height of the object visual representation in pixels.
       */
      function get componentHeight() : int;
   }
}