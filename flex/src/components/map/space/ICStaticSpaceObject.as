package components.map.space
{
   import models.IMStaticSpaceObject;
   import models.location.LocationMinimal;
   
   import mx.core.IVisualElement;
   
   
   public interface ICStaticSpaceObject extends IVisualElement
   {
      /**
       * Model of this static space object.
       */
      function set staticObject(value:IMStaticSpaceObject) : void;
      /**
       * @private
       */
      function get staticObject() : IMStaticSpaceObject;
      
      
      /**
       * Location where this object is.
       */
      function get currentLocation() : LocationMinimal;
   }
}