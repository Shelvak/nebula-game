package components.map.space
{
   import models.map.IMStaticSpaceObject;

   import mx.core.IVisualElement;


   public interface ICStaticSpaceObjectInfo extends IVisualElement
   {
      function set staticObject(value: IMStaticSpaceObject): void;
      function get staticObject(): IMStaticSpaceObject;
   }
}
