package components.map.space
{
   import components.base.Panel;

   import models.map.IMStaticSpaceObject;


   public class CStaticSpaceObjectInfo extends Panel implements ICStaticSpaceObjectInfo
   {
      private var _staticObject: IMStaticSpaceObject;
      [Bindable]
      public function set staticObject(value: IMStaticSpaceObject): void {
         if (_staticObject != value) {
            _staticObject = value;
         }
      }
      public function get staticObject(): IMStaticSpaceObject {
         return _staticObject;
      }
   }
}