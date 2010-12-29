package models
{
   import flash.display.BitmapData;
   
   import models.location.LocationMinimal;

   
   public interface IMStaticSpaceObject extends IBaseModel
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
      
      
      /**
       * Should return true if this object is navigable, that is if a user can open (view inside) it.
       */
      function get isNavigable() : Boolean;
      
      
      /**
       * If <code>isNavigable</code> returns <code>true</code>, should open this object and show it to the user.
       * Otherwise this may throw an error or just do nothing.
       */
      function navigateTo() : void;
   }
}