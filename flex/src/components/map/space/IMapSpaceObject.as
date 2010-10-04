package components.map.space
{
   import models.location.LocationMinimal;
   
   import mx.core.IVisualElement;
   
   
   /**
    * All objects that are positioned in Galaxy and Solar system maps must implement
    * this interface.
    */
   public interface IMapSpaceObject extends IVisualElement
   {
      /**
       * Model of location where the object currently is.
       */
      function get currentLocation() : LocationMinimal;
   }
}