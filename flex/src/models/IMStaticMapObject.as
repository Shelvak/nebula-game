package models
{
   import models.location.LocationMinimal;
   
   
   public interface IMStaticMapObject extends IBaseModel
   {
      /**
       * Should return true if this object is navigable, that is if a user can open (view inside) it.
       */
      function get isNavigable() : Boolean;
      
      
      /**
       * If <code>isNavigable</code> returns <code>true</code>, should open this object and show it to the
       * user. Otherwise this may throw an error or just do nothing.
       */
      function navigateTo() : void;
      
      
      /**
       * Location of this static space object.
       */
      function get currentLocation() : LocationMinimal;
   }
}