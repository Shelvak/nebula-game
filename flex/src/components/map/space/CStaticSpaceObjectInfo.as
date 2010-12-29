package components.map.space
{
   import components.base.Panel;
   
   import models.IMStaticSpaceObject;
   
   
   public class CStaticSpaceObjectInfo extends Panel
   {
      public function CStaticSpaceObjectInfo()
      {
         super();
      }
      
      
      private var _staticObject:IMStaticSpaceObject;
      [Bindable]
      public function set staticObject(value:IMStaticSpaceObject) : void
      {
         if (_staticObject != value)
         {
            _staticObject = value;
         }
      }
      /**
       * @private
       */
      public function get staticObject() : IMStaticSpaceObject
      {
         return _staticObject;
      }
   }
}