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
       * Location this object should be (and in most cases is).
       */
      function get locationCurrent() : LocationMinimal;
   }
}