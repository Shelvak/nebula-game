package models
{
   import flash.display.BitmapData;
   
   import models.location.LocationMinimal;

   
   public interface IStaticSpaceObject extends IBaseModel
   {
      /**
       * 
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
   }
}